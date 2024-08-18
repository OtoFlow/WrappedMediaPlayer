//
//  LocalMediaEndpoint.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/18.
//

import Foundation

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

    public var currentTime: TimeInterval {
        audioPlayer.currentTime
    }

    public var duration: TimeInterval {
        audioPlayer.duration
    }

    public weak var delegate: (any MediaPlaybackDelegate<Item>)?

    public weak var playerDelegate: WrappedPlayerDelegate? {
        didSet {
            audioPlayer.delegate = playerDelegate
        }
    }

    public let configuration: Configuration

    private var currentItem: Item?

    public init(configuration: Configuration = .init()) {
        self.configuration = configuration

        let audioPlayer = configuration.audioEngine.wrappedPlayer()

        self.audioPlayer = audioPlayer
        self.videoPlayer = configuration.createVideoEngine ? VideoPlayer.create() : audioPlayer as? VideoPlayer.Endpoint
    }

    public func loadFile(url: URL) {
        player.loadFile(url: url)
    }

    public func play(_ item: Item) {
        guard let url = item.getSourceUrl() else {
            return
        }

        currentItem = item

        player.loadFile(url: url)
        player.play()

        delegate?.playback(itemChanged: item)
    }

    public func play(_ items: [Item]) {

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

    public func seek(by offset: TimeInterval) {
        player.seek(by: offset)
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

extension LocalMediaEndpoint: WrappedPlayerDelegate {

    public func player(_ player: any WrappedPlayer, stateChanged newState: MediaState) {
        playerDelegate?.player(player, stateChanged: newState)
    }

    public func player(_ player: any WrappedPlayer, seekTo seconds: TimeInterval, finished: Bool) {
        playerDelegate?.player(player, seekTo: seconds, finished: finished)
    }

    public func player(_ player: any WrappedPlayer, secondsElapse seconds: TimeInterval) {
        playerDelegate?.player(player, secondsElapse: seconds)
    }
}
