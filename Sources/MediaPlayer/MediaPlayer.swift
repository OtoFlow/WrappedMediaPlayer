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

    @Published
    public var items: [Item] = []

    public var upcomingItems: [Item] {
        endpoint.upcomingItems
    }

    public var endpoint: Endpoint

    private lazy var remoteCommandController = RemoteCommandController(self)

    private let nowPlayingController = NowPlayingInfoController()

    public var remoteCommands: [Command] = [] {
        didSet {
            remoteCommandController.setupCommands(remoteCommands)
        }
    }

    public var playbackRate: Float {
        get { endpoint.playbackRate }
        set { endpoint.playbackRate = newValue }
    }

    public var currentTime: TimeInterval {
        endpoint.currentTime
    }

    public var duration: TimeInterval {
        endpoint.duration
    }

    public init(endpoint: Endpoint) {
        self.endpoint = endpoint
        self.endpoint.delegate = self
    }

    public func play(_ item: Item) {
        endpoint.play(item)
    }

    public func play(_ items: [Item]) {
        endpoint.play(items)
    }

    public func append(_ item: Item, playWhenReady: Bool? = true) {
        endpoint.append(item, playWhenReady: playWhenReady)
    }

    public func append(_ items: [Item], playWhenReady: Bool? = true) {
        endpoint.append(items, playWhenReady: playWhenReady)
    }

    public func insertNext(_ item: Item, playWhenReady: Bool? = true) {
        endpoint.insertNext(item, playWhenReady: playWhenReady)
    }

    public func insertNext(_ items: [Item], playWhenReady: Bool? = true) {
        endpoint.insertNext(items, playWhenReady: playWhenReady)
    }

    @discardableResult
    public func previous(replayInterval seconds: TimeInterval? = nil) -> Item? {
        if let seconds, currentTime < seconds {
            seek(to: .zero)
            return currentItem
        } else {
            return endpoint.previous()
        }
    }

    @discardableResult
    public func next() -> Item? {
        endpoint.next()
    }

    @discardableResult
    public func jumpToItem(at index: Int, playWhenReady: Bool? = true) -> Item? {
        endpoint.jumpToItem(at: index, playWhenReady: playWhenReady)
    }

    @discardableResult
    public func jumpNext(_ count: Int) -> Item? {
        endpoint.jumpNext(count)
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

    public func seek(to seconds: TimeInterval) {
        endpoint.seek(to: seconds)
    }

    public func seek(by seconds: TimeInterval) {
        endpoint.seek(by: seconds)
    }
}

// MARK: - MediaPlaybackDelegate
extension MediaPlayer: MediaPlaybackDelegate {

    public func playback(itemChanged newItem: Item?) {
        currentItem = newItem

        guard let item = newItem else {
            nowPlayingController.updater.clear()
            return
        }

        nowPlayingController.updater
            .update(.assertURL, value: item.getSourceUrl())
            .update(.mediaType, value: item.getMediaType().nowPlaying.rawValue)
            .update(.title, value: item.getTitle())
            .update(.artist, value: item.getArtists())
            .update(.albumTitle, value: item.getAlbumTitle())

        Task { [weak self] in
            guard let artwork = await item.getArtwork() else {
                self?.nowPlayingController.updater.update(.artwork, value: nil)
                return
            }

            self?.nowPlayingController.updater.update(.artwork, value: .init(
                boundsSize: artwork.size,
                requestHandler: { _ in artwork }
            ))
        }
    }

    public func playback(itemsChanged newItems: [Item]) {
        items = newItems
    }
}

// MARK: - WrappedPlayerDelegate
extension MediaPlayer: WrappedPlayerDelegate {

    public func player(_ player: WrappedPlayer, stateChanged newState: MediaState) {
        state = newState

        nowPlayingController.playbackState = newState == .playing ? .playing : .paused

        nowPlayingController.updater.update(.rate, value: newState == .playing ? 1 : 0)
    }

    public func player(_ player: WrappedPlayer, seekTo seconds: TimeInterval, finished: Bool) {

    }

    public func player(_ player: WrappedPlayer, secondsElapse seconds: TimeInterval) {
        timeElapse = TimeElapse(seconds: seconds, currentTime: currentTime, duration: duration)

        nowPlayingController.updater
            .update(.currentTime, value: currentTime)
            .update(.duration, value: duration)
    }

    public func playerPlayToEndTime(_ player: any WrappedPlayer) {
        _ = endpoint.next()
    }
}
