//
//  MediaEndpoint.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/17.
//

import Foundation

public protocol MediaEndpoint {

    associatedtype Item: MediaItem

    var currentTime: TimeInterval { get }

    var duration: TimeInterval { get }

    var delegate: (any MediaPlaybackDelegate<Item>)? { get set }

    func loadFile(url: URL)

    func play(_ item: Item)

    func play(_ items: [Item])

    func append(_ item: Item, playWhenReady: Bool?)

    func append(_ items: [Item], playWhenReady: Bool?)

    func insert(_ item: Item, at index: Int)

    func previous() -> Item?

    func next() -> Item?

    func jumpToItem(at index: Int) -> Item?

    func play()

    func pause()

    func stop()

    func seek(to seconds: TimeInterval)

    func seek(by offset: TimeInterval)
}

public typealias AudioEndpoint = MediaEndpoint
public typealias VideoEndpoint = MediaEndpoint & VideoAssociation
