//
//  MPVPlayerWrapper.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/9.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation
import MPVPlayer

public final class MPVPlayerWrapper: WrappedPlayer {

    private var player: MPVPlayer

    private var playerTimeObserver = MPVPlayerTimeObserver()

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
        player.playbackTime
    }

    public var duration: TimeInterval {
        player.duration
    }

    public weak var delegate: WrappedPlayerDelegate?

    public func loadFile(url: URL) {
        player.loadFile(url: url)
    }

    public func play() {
        player.play()
    }

    public func pause() {
        player.pause()
    }

    public func stop() {
        player.stop()
    }

    public func seek(to seconds: TimeInterval) {
        player.seek(to: seconds)
    }

    public func seek(by seconds: TimeInterval) {
        player.seek(by: seconds)
    }

    init(_ player: MPVPlayer = .init()) {
        self.player = player

        player.delegate = self

        setupObservers()
    }

    private func setupObservers() {
        playerTimeObserver.delegate = self

        playerTimeObserver.startObserving(player: player)
    }
}

extension MPVPlayerWrapper: VideoAssociation {

    public static func create() -> MPVPlayerWrapper? {
        MPVPlayerWrapper()
    }

    public func associate(with contentView: MPVPlayerContentView) {
        player.metalLayer = contentView.metalLayer
    }

    public func dissociate(from contentView: MPVPlayerContentView) {
        player.metalLayer = nil
    }
}

extension MPVPlayerWrapper: MPVPlayer.Delegate {

    public func player(_ player: MPVPlayer, stateChanged newState: MPVPlayer.State) {
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
