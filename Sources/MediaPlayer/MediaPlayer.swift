//
//  MediaPlayer.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation
import Combine

public struct TimeElapse {

    static var frozen = TimeElapse(seconds: .zero, currentTime: .zero, duration: .zero)

    public var seconds: TimeInterval

    public var currentTime: TimeInterval

    public var duration: TimeInterval
}

open class MediaPlayer<T: MediaEndpoint> {

    public typealias Endpoint = T
    public typealias Item = Endpoint.Item

    @Published
    public var state: MediaState = .idle

    @Published
    public var timeElapse: TimeElapse = .frozen

    @Published
    public var currentItem: Item?

    public var upcomingItems: [Item] {
        []
    }

    public var endpoint: Endpoint

    public var currentTime: TimeInterval {
        endpoint.currentTime
    }

    public var duration: TimeInterval {
        endpoint.duration
    }

    public init(endpoint: Endpoint) {
        self.endpoint = endpoint
        self.endpoint.delegate = self
        self.endpoint.playerDelegate = self
    }

    public func play(_ item: Item) {
        endpoint.play(item)
    }

    public func play() {
        endpoint.play()
    }

    public func pause() {
        endpoint.pause()
    }

    public func stop() {
        endpoint.stop()
    }

    public func previous(replayInterval seconds: TimeInterval? = nil) {
        if let seconds, currentTime < seconds {
            seek(to: .zero)
        } else {
            
        }
    }

    public func next() {

    }

    public func seek(to seconds: TimeInterval) {
        endpoint.seek(to: seconds)
    }

    public func seek(by seconds: TimeInterval) {
        endpoint.seek(by: seconds)
    }
}

// MARK: - MediaPlaybackDelegate
extension MediaPlayer: MediaPlaybackDelegate {

    public func playback(itemChanged item: Item?) {
        currentItem = item
    }
}

// MARK: - WrappedPlayerDelegate
extension MediaPlayer: WrappedPlayerDelegate {

    public func player(_ player: WrappedPlayer, stateChanged newState: MediaState) {
        state = newState
    }

    public func player(_ player: WrappedPlayer, seekTo seconds: TimeInterval, finished: Bool) {

    }

    public func player(_ player: WrappedPlayer, secondsElapse seconds: TimeInterval) {
        timeElapse = TimeElapse(seconds: seconds, currentTime: currentTime, duration: duration)
    }
}
