//
//  MPVPlayerTimeObserver.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/10.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import CoreMedia
import MPVPlayer

class MPVPlayerTimeObserver: NSObject {

    enum Constant {
        static var periodicTime: TimeInterval = 1.0
    }

    private var player: MPVPlayer!

    weak var delegate: Delegate?

    private var periodicTimeObservation: Timer?

    deinit {
        stopObserving()
    }

    func startObserving(player thePlayer: MPVPlayer) {
        player = thePlayer

        periodicTimeObservation = thePlayer.addPeriodicTimeObserver(forInterval: Constant.periodicTime) { [unowned self] time in
            delegate?.player(player, timeChanged: time)
        }
    }

    func stopObserving() {
        periodicTimeObservation.map(player.removeTimeObserver(_:))
    }
}

extension MPVPlayerTimeObserver {

    protocol Delegate: AnyObject {

        func player(_ player: MPVPlayer, timeChanged time: TimeInterval)
    }
}
