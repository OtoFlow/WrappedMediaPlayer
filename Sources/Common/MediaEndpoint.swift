//
//  MediaEndpoint.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/17.
//

import Foundation

public protocol MediaEndpoint {

    associatedtype Item: MediaItem

    var playbackRate: Float { get set }

    var currentTime: TimeInterval { get }

    var duration: TimeInterval { get }

    var upcomingItems: [Item] { get }

    var delegate: (any MediaPlaybackDelegate<Item>)? { get set }

    func loadFile(url: URL)

    func play(_ item: Item)

    func play(_ items: [Item])

    func append(_ item: Item, playWhenReady: Bool?)

    func append(_ items: [Item], playWhenReady: Bool?)

    func insert(_ item: Item, at index: Int)

    func insert(_ items: [Item], at index: Int)

    func insertNext(_ item: Item, playWhenReady: Bool?)

    func insertNext(_ items: [Item], playWhenReady: Bool?)

    func previous() -> Item?

    func next(playWhenReady: Bool?) -> Item?

    func jumpToItem(at index: Int, playWhenReady: Bool?) -> Item?

    func jumpNext(_ count: Int) -> Item?

    func play()

    func pause()

    func stop()

    func seek(to seconds: TimeInterval)

    func seek(by seconds: TimeInterval)

    func seek(to seconds: TimeInterval) async -> Bool

    func seek(by seconds: TimeInterval) async -> Bool
}

public typealias AudioEndpoint = MediaEndpoint
public typealias VideoEndpoint = MediaEndpoint & VideoAssociation
