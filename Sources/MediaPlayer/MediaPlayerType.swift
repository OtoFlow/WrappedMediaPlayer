//
//  MediaPlayerType.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation

public protocol MediaPlayerType: AnyObject {

    var state: MediaPlayer.State { get set }

    var currentTime: TimeInterval { get }

    var duration: TimeInterval { get }

    var delegate: MediaPlayer.Delegate? { get set }

    func loadFile(url: URL)

    func play()

    func pause()

    func stop()

    func seek(to seconds: TimeInterval)

    func seek(by offset: TimeInterval)
}
