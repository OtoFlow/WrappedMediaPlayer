//
//  Engine.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation

extension LocalMediaEndpoint {

    public enum Engine {

        case system

        case mpv
    }
}

extension LocalMediaEndpoint.Engine {

    func wrappedPlayer() -> WrappedPlayer {
        switch self {
        case .system:
            AVPlayerWrapper()
        case .mpv:
            MPVPlayerWrapper()
        }
    }
}
