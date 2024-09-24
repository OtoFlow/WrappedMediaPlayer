//
//  LocalMediaEndpoint.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/18.
//

import Foundation
import Combine

public final class LocalMediaEndpoint<V: WrappedVideoPlayer, Item: MediaItem>: MediaEndpoint {

    public typealias VideoPlayer = V

    public private(set) var audioPlayer: WrappedPlayer

    public var videoPlayer: VideoPlayer.Endpoint?

    private var player: WrappedPlayer {
        guard let item = currentItem else {
            return audioPlayer
        }
        switch item.getMediaType() {
        case .audio:
            return audioPlayer
        case .video:
            return videoPlayer ?? audioPlayer
        }
    }

    public var playbackRate: Float {
        get { audioPlayer.rate }
        set { audioPlayer.rate = newValue }
    }

    public var currentTime: TimeInterval {
        audioPlayer.currentTime
    }

    public var duration: TimeInterval {
        audioPlayer.duration
    }

    public var upcomingItems: [Item] {
        queue.nextItems
    }

    public weak var delegate: (any MediaPlaybackDelegate<Item>)? {
        didSet {
            audioPlayer.delegate = delegate
        }
    }

    private var queue = QueueManager<Item>()

    private(set) var currentItem: Item?

    public let configuration: Configuration

    private var cancellables = Set<AnyCancellable>()

    public init(configuration: Configuration = .init()) {
        self.configuration = configuration

        let audioPlayer = configuration.audioEngine.wrappedPlayer()

        self.audioPlayer = audioPlayer
        self.videoPlayer = configuration.createVideoEngine ? VideoPlayer.create() : audioPlayer as? VideoPlayer.Endpoint

        setupBindings()
    }

    private func setupBindings() {
        queue.$currentItem
            .sink { [unowned self] item in
                currentItem = item
                delegate?.playback(itemChanged: item)
                item.map(load(item:))
            }
            .store(in: &cancellables)

        queue.$items
            .sink { [unowned self] items in
                delegate?.playback(itemsChanged: items)
            }
            .store(in: &cancellables)
    }

    private var playWhenReady: Bool {
        get { player.playWhenReady }
        set { player.playWhenReady = newValue }
    }

    private func handlePlayWhenReady<T>(_ playWhenReady: Bool?, _ closure: () -> T) -> T {
        if playWhenReady == false {
            self.playWhenReady = false
        }

        defer {
            if playWhenReady == true {
                self.playWhenReady = true
            }
        }

        return closure()
    }

    func load(item: Item) {
        player.loadMedia(item: item)
    }

    public func loadFile(url: URL) {
        player.loadFile(url: url)
    }

    public func play(_ item: Item) {
        handlePlayWhenReady(true) {
            queue.replace(using: item)
        }
    }

    public func play(_ items: [Item]) {
        handlePlayWhenReady(true) {
            queue.replace(using: items)
        }
    }

    public func append(_ item: Item, playWhenReady: Bool?) {
        handlePlayWhenReady(playWhenReady) {
            queue.append(item)
        }
    }

    public func append(_ items: [Item], playWhenReady: Bool?) {
        handlePlayWhenReady(playWhenReady) {
            queue.append(items)
        }
    }

    public func insert(_ item: Item, at index: Int) {
        queue.insert(item, at: index)
    }

    public func insert(_ items: [Item], at index: Int) {
        queue.insert(items, at: index)
    }

    public func insertNext(_ item: Item, playWhenReady: Bool?) {
        handlePlayWhenReady(playWhenReady) {
            queue.insertNext(item)
        }
    }

    public func insertNext(_ items: [Item], playWhenReady: Bool?) {
        handlePlayWhenReady(playWhenReady) {
            queue.insertNext(items)
        }
    }

    public func previous() -> Item? {
        queue.previous()
    }

    public func next(playWhenReady: Bool?) -> Item? {
        handlePlayWhenReady(playWhenReady) {
            queue.next(cycle: true)
        }
    }

    public func jumpToItem(at index: Int, playWhenReady: Bool?) -> Item? {
        handlePlayWhenReady(playWhenReady) {
            queue.jump(to: index)
        }
    }

    public func jumpNext(_ count: Int) -> Item? {
        queue.jumpNext(count)
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

    public func seek(to seconds: TimeInterval) async -> Bool {
        await player.seek(to: seconds)
    }

    public func seek(by seconds: TimeInterval) async -> Bool {
        await player.seek(by: seconds)
    }
}

extension LocalMediaEndpoint: VideoAssociation {

    public static func create() -> VideoPlayer.Endpoint? {
        VideoPlayer.create()
    }

    public func associate(with contentView: VideoPlayer.Endpoint.ContentView) {
        videoPlayer?.associate(with: contentView)
    }

    public func dissociate(from contentView: VideoPlayer.Endpoint.ContentView) {
        videoPlayer?.dissociate(from: contentView)
    }
}
