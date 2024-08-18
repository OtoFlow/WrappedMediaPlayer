//
//  NoneVideoEndpoint.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/17.
//

import Foundation

public enum NoneVideoEndpoint: VideoEndpoint {

    public var currentTime: TimeInterval {
        .zero
    }

    public var duration: TimeInterval {
        .zero
    }

    public var delegate: (any MediaPlaybackDelegate<AnyMediaItem>)? {
        get { nil }
        set { }
    }

    public var playerDelegate: (any WrappedPlayerDelegate)? {
        get { nil }
        set { }
    }

    public func loadFile(url: URL) {

    }

    public func play(_ item: AnyMediaItem) {

    }

    public func play(_ items: [AnyMediaItem]) {

    }

    public func play() {

    }

    public func pause() {

    }

    public func stop() {

    }

    public func seek(to seconds: TimeInterval) {

    }

    public func seek(by offset: TimeInterval) {

    }

    public static func create() -> AVPlayerWrapper? {
        nil
    }

    public func associate(with contentView: VideoContentView) {

    }

    public func dissociate(from contentView: VideoContentView) {

    }
}
