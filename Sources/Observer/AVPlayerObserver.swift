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

    private var itemStatusObserver: NSObjectProtocol!
    private var statusObserver: NSObjectProtocol!
    private var timeControlObserver: NSObjectProtocol!

    func startObserving(player thePlayer: AVPlayer) {
        stopObserveing()

        player = thePlayer

        itemStatusObserver = thePlayer.observe(\.currentItem?.status, options: .initial) { [unowned self] _, _ in
            delegate?.player(player, itemStatusChanged: player.currentItem?.status ?? .unknown)
        }

        statusObserver = thePlayer.observe(\.status, options: [.initial, .new]) { [unowned self] _, _ in
            delegate?.player(player, statusChanged: player.status)
        }

        timeControlObserver = thePlayer.observe(\.timeControlStatus, options: .new) { [unowned self] _, _ in
            delegate?.player(player, timeControlStatusChanged: player.timeControlStatus)
        }
    }

    func stopObserveing() {
        itemStatusObserver = nil
        statusObserver = nil
        timeControlObserver = nil
    }
}

extension AVPlayerObserver {

    protocol Delegate: AnyObject {

        func player(_ player: AVPlayer, itemStatusChanged status: AVPlayerItem.Status)

        func player(_ player: AVPlayer, statusChanged status: AVPlayer.Status)

        func player(_ player: AVPlayer, timeControlStatusChanged timeControlStatus: AVPlayer.TimeControlStatus)
    }
}
