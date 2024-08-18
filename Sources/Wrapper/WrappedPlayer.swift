//
//  WrappedPlayer.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/18.
//

import Foundation

public protocol WrappedPlayer {

    var currentTime: TimeInterval { get }

    var duration: TimeInterval { get }

    var delegate: WrappedPlayerDelegate? { get set }

    func loadFile(url: URL)

    func play()

    func pause()

    func stop()

    func seek(to seconds: TimeInterval)

    func seek(by offset: TimeInterval)
}

public protocol VideoAssociation {

    associatedtype Endpoint: WrappedVideoPlayer

    associatedtype ContentView: VideoContentView

    static func create() -> Endpoint?

    func associate(with contentView: ContentView)

    func dissociate(from contentView: ContentView)
}

public typealias WrappedAudioPlayer = WrappedPlayer
public typealias WrappedVideoPlayer = WrappedPlayer & VideoAssociation
