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

    var playerDelegate: WrappedPlayerDelegate? { get set }

    func loadFile(url: URL)

    func play(_ item: Item)

    func play(_ items: [Item])

    func play()

    func pause()

    func stop()

    func seek(to seconds: TimeInterval)

    func seek(by offset: TimeInterval)
}

public typealias AudioEndpoint = MediaEndpoint
public typealias VideoEndpoint = MediaEndpoint & VideoAssociation
