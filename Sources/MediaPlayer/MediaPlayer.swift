//
//  MediaPlayer.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation
import Combine

public class MediaPlayer {

    public struct TimeElapse {

        static var frozen = TimeElapse(seconds: .zero, currentTime: .zero, duration: .zero)

        public var seconds: TimeInterval

        public var currentTime: TimeInterval

        public var duration: TimeInterval
    }

    @Published
    public var state: State = .idle

    @Published
    public var timeElapse: TimeElapse = .frozen

    private var wrappedPlayer: MediaPlayerType

    public var configuration: Configuration

    private var contentViewConfigure: ((VideoPlayerContentView) -> ())?

    public var currentTime: TimeInterval {
        wrappedPlayer.currentTime
    }

    public var duration: TimeInterval {
        wrappedPlayer.duration
    }

    public init(configuration: Configuration) {
        self.configuration = configuration

        var contentViewConfigure: ((VideoPlayerContentView) -> ())?

        wrappedPlayer = configuration.wrappedPlayer { binding in
            contentViewConfigure = binding
        }
        wrappedPlayer.delegate = self

        self.contentViewConfigure = contentViewConfigure
    }

    func wire(to contentView: VideoPlayerContentView) {
        contentViewConfigure?(contentView)
        contentViewConfigure = nil
    }

    public func loadFile(url: URL) {
        wrappedPlayer.loadFile(url: url)
    }

    public func play() {
        wrappedPlayer.play()
    }

    public func pause() {
        wrappedPlayer.pause()
    }

    public func stop() {
        wrappedPlayer.stop()
    }

    public func seek(to seconds: TimeInterval) {
        wrappedPlayer.seek(to: seconds)
    }

    public func seek(by seconds: TimeInterval) {
        wrappedPlayer.seek(by: seconds)
    }
}

extension MediaPlayer: MediaPlayer.Delegate {

    public func player(_ player: MediaPlayerType, stateChanged state: State) {
        self.state = state
    }

    public func player(_ player: MediaPlayerType, seekTo seconds: TimeInterval, finished: Bool) {

    }

    public func player(_ player: MediaPlayerType, secondsElapse seconds: TimeInterval) {
        timeElapse = TimeElapse(seconds: seconds, currentTime: currentTime, duration: duration)
    }
}
