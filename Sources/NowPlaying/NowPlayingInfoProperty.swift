//
//  NowPlayingInfoProperty.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/9/10.
//

import MediaPlayer

public class _AnyNowPlayingInfoProperty {

    public let name: String

    fileprivate init(name: String) {
        self.name = name
    }
}

public class NowPlayingInfoProperty<Value>: _AnyNowPlayingInfoProperty {

    fileprivate init(_ name: String) {
        super.init(name: name)
    }
}

public typealias NowPlayingInfoProperties = _AnyNowPlayingInfoProperty

private typealias Property = NowPlayingInfoProperty

extension NowPlayingInfoProperties {

    public static var artwork     = Property<MPMediaItemArtwork?>(MPMediaItemPropertyArtwork)

    public static var title       = Property<String?>(MPMediaItemPropertyTitle)

    public static var artist      = Property<String?>(MPMediaItemPropertyArtist)

    public static var albumTitle  = Property<String?>(MPMediaItemPropertyAlbumTitle)

    public static var albumArtist = Property<String?>(MPMediaItemPropertyAlbumArtist)

    public static var duration    = Property<TimeInterval>(MPMediaItemPropertyPlaybackDuration)

    public static var currentTime = Property<TimeInterval>(MPNowPlayingInfoPropertyElapsedPlaybackTime)

    public static var progress    = Property<Double>(MPNowPlayingInfoPropertyPlaybackProgress)

    public static var rate        = Property<Float>(MPNowPlayingInfoPropertyPlaybackRate)

    public static var id          = Property<String?>(MPNowPlayingInfoPropertyExternalContentIdentifier)

    public static var mediaType   = Property<UInt>(MPNowPlayingInfoPropertyMediaType)

    public static var assertURL   = Property<URL>(MPNowPlayingInfoPropertyAssetURL)
}
