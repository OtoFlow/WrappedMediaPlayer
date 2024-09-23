//
//  AVPlayerTimeObserver.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/8.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import AVFoundation

class AVPlayerTimeObserver: NSObject {

    enum Constant {
        static var boundaryTime = CMTime(value: 1, timescale: 1000)
        static var periodicTime = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    }

    private var player: AVPlayer!

    weak var delegate: Delegate?

    private var periodicTimeObservation: Any?

    deinit {
        stopObserving()
    }

    func startObserving(player thePlayer: AVPlayer) {
        player = thePlayer

        periodicTimeObservation = thePlayer.addPeriodicTimeObserver(forInterval: Constant.periodicTime, queue: nil) { [unowned self] time in
            delegate?.player(player, timeChanged: time)
        }
    }

    func stopObserving() {
        periodicTimeObservation.map(player.removeTimeObserver(_:))
    }
}

extension AVPlayerTimeObserver {

    protocol Delegate: AnyObject {

        func player(_ player: AVPlayer, timeChanged time: CMTime)
    }
}
