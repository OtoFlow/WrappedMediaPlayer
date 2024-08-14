//
//  MPVPlayerWrapper.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/9.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation
import MPVPlayer

class MPVPlayerWrapper: MediaPlayerType {

    private var player: MPVPlayer

    private var playerTimeObserver = MPVPlayerTimeObserver()

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
        player.playbackTime
    }

    var duration: TimeInterval {
        player.duration
    }

    weak var delegate: MediaPlayer.Delegate?

    init(_ player: MPVPlayer = .init()) {
        self.player = player

        player.delegate = self

        setupObservation()
    }

    private func setupObservation() {
        playerTimeObserver.delegate = self

        playerTimeObserver.startObserving(player: player)
    }

    func loadFile(url: URL) {
        player.loadFile(url: url)
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func stop() {

    }

    func seek(to seconds: TimeInterval) {
        player.seek(to: seconds)
    }

    func seek(by seconds: TimeInterval) {
        player.seek(by: seconds)
    }
}

extension MPVPlayerWrapper: MPVPlayer.Delegate {

    func player(_ player: MPVPlayer, stateChanged newState: MPVPlayer.State) {
        switch newState {
        case .playing:
            state = .playing
        case .paused:
            state = .paused
        default: ()
        }
    }
}

extension MPVPlayerWrapper: MPVPlayerTimeObserver.Delegate {

    func player(_ player: MPVPlayer, timeChanged time: TimeInterval) {
        delegate?.player(self, secondsElapse: time)
        state = player.isPaused ? .paused : .playing
    }
}
