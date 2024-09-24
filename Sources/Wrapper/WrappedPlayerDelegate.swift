//
//  WrappedPlayerDelegate.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/8/17.
//

import Foundation

public protocol WrappedPlayerDelegate: AnyObject {

    func player(_ player: WrappedPlayer, itemStateChanged newState: MediaItemState)

    func player(_ player: WrappedPlayer, stateChanged newState: MediaState)

    func player(_ player: WrappedPlayer, seekTo seconds: TimeInterval, finished: Bool)

    func player(_ player: WrappedPlayer, secondsElapse seconds: TimeInterval)

    func playerPlayToEndTime(_ player: WrappedPlayer)
}
