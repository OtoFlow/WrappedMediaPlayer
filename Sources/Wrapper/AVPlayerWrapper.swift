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

    public var currentTime: TimeInterval {
        let seconds = player.currentTime().seconds
        return seconds.isNaN ? .zero : seconds
    }

    public var duration: TimeInterval {
        if let seconds = player.currentItem?.duration.seconds, !seconds.isNaN {
            return seconds
        } else if let seconds = player.currentItem?.seekableTimeRanges.last?.timeRangeValue.duration.seconds,
                  !seconds.isNaN {
            return seconds
        }
        return .zero
    }

    public weak var delegate: WrappedPlayerDelegate?

    public func loadFile(url: URL) {
        player.replaceCurrentItem(with: .init(url: url))
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
        if player.currentItem == nil {
//            timeToSeekToAfterLoading = seconds
        } else {
            let time = CMTimeMakeWithSeconds(seconds, preferredTimescale: 1000)
            player.seek(to: time) { finished in
                self.delegate?.player(self, seekTo: time.seconds, finished: finished)
            }
        }
    }

    public func seek(by offset: TimeInterval) {

    }

    init(_ player: AVPlayer = .init()) {
        self.player = player

        setupAVPlayer()
    }

    private func setupAVPlayer() {
        setupObservers()

        applyAVPlayerRate()
    }

    private func setupObservers() {
        playerObserver.delegate = self
        playerTimeObserver.delegate = self

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

    func player(_ player: AVPlayer, statusChanged status: AVPlayer.Status) {
        switch status {
        case .readyToPlay:
            state = .idle
        case .failed:
            state = .failed
        default: ()
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
