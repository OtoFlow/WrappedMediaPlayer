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

    func startObserving(player thePlayer: AVPlayer) {
        stopObserveing()

        player = thePlayer

        thePlayer.addObserver(self, for: \.status, options: [.initial, .new], context: &Self.context)
        thePlayer.addObserver(self, for: \.timeControlStatus, options: [.new], context: &Self.context)
    }

    func stopObserveing() {
        player?.removeObserver(self, for: \.status)
        player?.removeObserver(self, for: \.timeControlStatus)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &Self.context, let keyPath else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }

        switch keyPath {
        case #keyPath(AVPlayer.status):
            handleStatusChange(change)
        case #keyPath(AVPlayer.timeControlStatus):
            handleTimeControlStatusChange(change)
        default: ()
        }
    }

    private func handleStatusChange(_ change: [NSKeyValueChangeKey: Any]?) {
        let status: AVPlayer.Status
        if let statusNumber = change?[.newKey] as? NSNumber {
            status = AVPlayer.Status(rawValue: statusNumber.intValue)!
        } else {
            status = .unknown
        }
        delegate?.player(player, statusChanged: status)
    }

    private func handleTimeControlStatusChange(_ change: [NSKeyValueChangeKey: Any]?) {
        let status: AVPlayer.TimeControlStatus
        if let statusNumber = change?[.newKey] as? NSNumber {
            status = AVPlayer.TimeControlStatus(rawValue: statusNumber.intValue)!
            delegate?.player(player, timeControlStatusChanged: status)
        }
    }
}

extension AVPlayerObserver {

    protocol Delegate: AnyObject {

        func player(_ player: AVPlayer, statusChanged status: AVPlayer.Status)

        func player(_ player: AVPlayer, timeControlStatusChanged timeControlStatus: AVPlayer.TimeControlStatus)
    }
}
