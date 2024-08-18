//
//  MediaPlaybackDelegate.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/18.
//

public protocol MediaPlaybackDelegate<Item>: AnyObject {

    associatedtype Item: MediaItem

    func playback(itemChanged item: Item?)
}
