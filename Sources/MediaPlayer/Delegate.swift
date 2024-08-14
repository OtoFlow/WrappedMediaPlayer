//
//  Delegate.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/8.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation

extension MediaPlayer {

    public protocol Delegate: AnyObject {

        func player(_ player: MediaPlayerType, stateChanged state: State)

        func player(_ player: MediaPlayerType, seekTo seconds: TimeInterval, finished: Bool)

        func player(_ player: MediaPlayerType, secondsElapse seconds: TimeInterval)
    }
}

extension MediaPlayer.Delegate {

    public func player(_ player: MediaPlayerType, stateChanged state: MediaPlayer.State) {

    }

    public func player(_ player: MediaPlayerType, seekTo seconds: TimeInterval, finished: Bool) {

    }

    public func player(_ player: MediaPlayerType, secondsElapse seconds: TimeInterval) {

    }
}
