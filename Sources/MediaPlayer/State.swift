//
//  State.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/8.
//  Copyright © 2024 foyoodo. All rights reserved.
//

extension MediaPlayer {

    public enum State {

        case loading

        case readyToPlay

        case buffering

        case paused

        case stopped

        case playing

        case idle

        case failed

        case ended
    }
}
