//
//  MediaItem.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/18.
//

import UIKit
import MediaPlayer

public enum MediaType {

    case audio

    case video
}

extension MediaType {

    var nowPlaying: MPNowPlayingInfoMediaType {
        switch self {
        case .audio: .audio
        case .video: .video
        }
    }
}

public protocol MediaItem {

    func getMediaType() -> MediaType

    func getSourceUrl() -> URL

    func getArtists() -> String?

    func getTitle() -> String?

    func getAlbumTitle() -> String?

    func getArtwork() async -> UIImage?

    func getArtworkIdentifier() -> String?
}

extension MediaItem {

    public func getMediaType() -> MediaType {
        .audio
    }

    public func getArtworkIdentifier() -> String? {
        nil
    }
}

public struct AnyMediaItem: MediaItem {

    public let base: MediaItem

    public init(base: MediaItem) {
        self.base = base
    }

    public func getSourceUrl() -> URL {
        base.getSourceUrl()
    }

    public func getArtists() -> String? {
        base.getArtists()
    }

    public func getTitle() -> String? {
        base.getTitle()
    }

    public func getAlbumTitle() -> String? {
        base.getAlbumTitle()
    }

    public func getArtwork() async -> UIImage? {
        await base.getArtwork()
    }

    public func getArtworkIdentifier() -> String? {
        base.getArtworkIdentifier()
    }
}
