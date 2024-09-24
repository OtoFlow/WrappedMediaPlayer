//
//  MediaState.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/17.
//

public enum MediaState {

    case readyToPlay

    case buffering

    case paused

    case stopped

    case playing

    case idle

    case failed

    case ended
}

public enum MediaItemState {

    case readyToPlay

    case failed

    case idle
}
