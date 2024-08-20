//
//  MediaPlaybackDelegate.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/18.
//

public protocol MediaPlaybackDelegate<Item>: AnyObject, WrappedPlayerDelegate {

    associatedtype Item: MediaItem

    func playback(itemChanged newItem: Item?)

    func playback(itemsChanged newItems: [Item])
}
