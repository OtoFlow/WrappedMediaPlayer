//
//  AVPlayerWrapper.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import AVFoundation

public final class AVPlayerWrapper: WrappedPlayer {

    private var player: AVPlayer

    private var playerObserver = AVPlayerObserver()
    private var playerTimeObserver = AVPlayerTimeObserver()
    private var playerItemNotificationObserver = AVPlayerItemNotificationObserver()

    public var playWhenReady: Bool = false {
        didSet {
            applyAVPlayerRate()
        }
    }

    public var rate: Float = 1.0 {
        didSet {
            player.rate = rate

            if #available(iOS 16.0, *) {
                player.defaultRate = rate
            }
        }
    }

    var _state: MediaState = .idle
    public var state: MediaState {
        get { _state }
        set {
            if _state != newValue {
                _state = newValue
                delegate?.player(self, stateChanged: newValue)
            }
        }
    }

    public private(set) var itemState: MediaItemState = .idle {
        didSet {
            delegate?.player(self, itemStateChanged: itemState)
        }
    }

    public var currentTime: TimeInterval {
        let seconds = player.currentTime().seconds
        return seconds.isNaN ? .zero : seconds
    }

    public var duration: TimeInterval {
        guard let currentItem = player.currentItem else {
            return .zero
        }

        let seconds = currentItem.duration.seconds
        if !seconds.isNaN {
            return seconds
        }

        if let seconds = currentItem.seekableTimeRanges.last?.timeRangeValue.duration.seconds, !seconds.isNaN {
            return seconds
        }

        return .zero
    }

    public weak var delegate: WrappedPlayerDelegate?

    public func loadFile(url: URL) {
        let item = AVPlayerItem(url: url)

        player.replaceCurrentItem(with: item)

        playerItemNotificationObserver.startObserving(playerItem: item)
    }

    public func loadMedia(item: any MediaItem) {
        player.allowsExternalPlayback = item.getMediaType() != .audio

        loadFile(url: item.getSourceUrl())
    }

    public func play() {
        player.play()
    }

    public func pause() {
        player.pause()
    }

    public func stop() {
        player.pause()
    }

    public func seek(to seconds: TimeInterval) {
        let time = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        if player.currentItem == nil {
//            timeToSeekToAfterLoading = seconds
        } else {
            player.seek(to: time) { isFinished in
                self.delegate?.player(self, seekTo: seconds, finished: isFinished)
            }
        }
    }

    public func seek(by seconds: TimeInterval) {

    }

    public func seek(to seconds: TimeInterval) async -> Bool {
        let time = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        if player.currentItem == nil {
//            timeToSeekToAfterLoading = seconds
            return false
        } else {
            let isFinished = await player.seek(to: time)
            delegate?.player(self, seekTo: seconds, finished: isFinished)
            return isFinished
        }
    }

    public func seek(by seconds: TimeInterval) async -> Bool {
        false
    }

    init(_ player: AVPlayer = .init()) {
        self.player = player

        player.usesExternalPlaybackWhileExternalScreenIsActive = true

        setupAVPlayer()
    }

    private func setupAVPlayer() {
        setupObservers()

        applyAVPlayerRate()
    }

    private func setupObservers() {
        playerObserver.delegate = self
        playerTimeObserver.delegate = self
        playerItemNotificationObserver.delegate = self

        playerObserver.startObserving(player: player)
        playerTimeObserver.startObserving(player: player)
    }

    private func applyAVPlayerRate() {
        player.rate = playWhenReady ? rate : 0.0
    }
}

extension AVPlayerWrapper: VideoAssociation {

    public static func create() -> AVPlayerWrapper? {
        AVPlayerWrapper()
    }

    public func associate(with contentView: AVPlayerContentView) {
        contentView.player = player
    }

    public func dissociate(from contentView: AVPlayerContentView) {
        contentView.player = nil
    }
}

// MARK: - AVPlayerObserver.Delegate
extension AVPlayerWrapper: AVPlayerObserver.Delegate {

    func player(_ player: AVPlayer, itemStatusChanged status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            itemState = .readyToPlay
        case .failed:
            itemState = .failed
        default:
            itemState = .idle
        }
    }

    func player(_ player: AVPlayer, statusChanged status: AVPlayer.Status) {
        switch status {
        case .readyToPlay:
            state = .readyToPlay
        case .failed:
            state = .failed
        default:
            state = .idle
        }
    }

    func player(_ player: AVPlayer, timeControlStatusChanged timeControlStatus: AVPlayer.TimeControlStatus) {
        switch timeControlStatus {
        case .paused:
            state = .paused
        case .waitingToPlayAtSpecifiedRate:
            state = .buffering
        case .playing:
            state = .playing
        @unknown default: ()
        }
    }
}

// MARK: - AVPlayerTimeObserver.Delegate
extension AVPlayerWrapper: AVPlayerTimeObserver.Delegate {

    func player(_ player: AVPlayer, timeChanged time: CMTime) {
        delegate?.player(self, secondsElapse: time.seconds)
    }
}

extension AVPlayerWrapper: AVPlayerItemNotificationObserver.Delegate {

    func playerItemPlayToEndTime(_ playerItem: AVPlayerItem) {
        delegate?.playerPlayToEndTime(self)
    }
}
