//
//  AVPlayerObserver.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/8.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import AVFoundation

class AVPlayerObserver: NSObject {

    private static var context = 0

    private var player: AVPlayer!

    weak var delegate: Delegate?

    private var statusObserver: NSObjectProtocol!
    private var timeControlObserver: NSObjectProtocol!

    func startObserving(player thePlayer: AVPlayer) {
        stopObserveing()

        player = thePlayer

        statusObserver = thePlayer.observe(\.currentItem?.status, options: .initial) { [unowned self] _, _ in
            delegate?.player(player, statusChanged: player.currentItem?.status ?? .unknown)
        }

        timeControlObserver = thePlayer.observe(\.timeControlStatus, options: .new) { [unowned self] _, _ in
            delegate?.player(player, timeControlStatusChanged: player.timeControlStatus)
        }
    }

    func stopObserveing() {
        statusObserver = nil
        timeControlObserver = nil
    }
}

extension AVPlayerObserver {

    protocol Delegate: AnyObject {

        func player(_ player: AVPlayer, statusChanged status: AVPlayerItem.Status)

        func player(_ player: AVPlayer, timeControlStatusChanged timeControlStatus: AVPlayer.TimeControlStatus)
    }
}
