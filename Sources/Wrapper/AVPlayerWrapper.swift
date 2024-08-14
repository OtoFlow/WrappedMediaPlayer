//
//  AVPlayerWrapper.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import AVFoundation

class AVPlayerWrapper: MediaPlayerType {

    private var player: AVPlayer

    private var playerObserver = AVPlayerObserver()

    private var playerTimeObserver = AVPlayerTimeObserver()

    var _state: MediaPlayer.State = .idle
    var state: MediaPlayer.State {
        get { _state }
        set {
            if _state != newValue {
                _state = newValue
                delegate?.player(self, stateChanged: newValue)
            }
        }
    }

    var currentTime: TimeInterval {
        let seconds = player.currentTime().seconds
        return seconds.isNaN ? .zero : seconds
    }

    var duration: TimeInterval {
        if let seconds = player.currentItem?.duration.seconds, !seconds.isNaN {
            return seconds
        } else if let seconds = player.currentItem?.seekableTimeRanges.last?.timeRangeValue.duration.seconds,
                  !seconds.isNaN {
            return seconds
        }
        return .zero
    }

    weak var delegate: MediaPlayer.Delegate?

    init(_ player: AVPlayer = .init()) {
        self.player = player

        setupObservation()
    }

    private func setupObservation() {
        playerObserver.delegate = self
        playerTimeObserver.delegate = self

        playerObserver.startObserving(player: player)
        playerTimeObserver.startObserving(player: player)
    }

    func loadFile(url: URL) {
        player.replaceCurrentItem(with: .init(url: url))
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func stop() {
        player.pause()
    }

    func seek(to seconds: TimeInterval) {
        if player.currentItem == nil {
//            timeToSeekToAfterLoading = seconds
        } else {
            let time = CMTimeMakeWithSeconds(seconds, preferredTimescale: 1000)
            player.seek(to: time) { finished in
                self.delegate?.player(self, seekTo: time.seconds, finished: finished)
            }
        }
    }

    func seek(by offset: TimeInterval) {

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
