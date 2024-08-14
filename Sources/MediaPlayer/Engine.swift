//
//  Engine.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import AVFoundation
import MPVPlayer

extension MediaPlayer {

    public enum Engine {

        case system

        case mpv
    }
}

extension MediaPlayer.Engine {

    func createContentView() -> VideoPlayerContentView {
        switch self {
        case .system:
            AVPlayerContentView()
        case .mpv:
            MPVPlayerContentView()
        }
    }
}

extension MediaPlayer.Configuration {

    func wrappedPlayer(contentViewConfigure closure: (@escaping (VideoPlayerContentView) -> ()) -> ()) -> MediaPlayerType {
        switch engine {
        case .system:
            let player = AVPlayer(url: url)
            closure { contentView in
                if case let playerContentView as AVPlayerContentView = contentView {
                    playerContentView.player = player
                }
            }
            return AVPlayerWrapper(player)
        case .mpv:
            let player = MPVPlayer()
            player.loadFile(url: url)
            closure { contentView in
                if case let contentView as MPVPlayerContentView = contentView {
                    player.metalLayer = contentView.metalLayer
                }
            }
            return MPVPlayerWrapper(player)
        }
    }
}
