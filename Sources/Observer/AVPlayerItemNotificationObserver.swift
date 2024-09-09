//
//  AVPlayerItemNotificationObserver.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/9/10.
//

import AVFoundation

class AVPlayerItemNotificationObserver: NSObject {

    private var notificationCenter: NotificationCenter { .default }

    private var playerItem: AVPlayerItem?

    weak var delegate: Delegate?

    deinit {
        stopObserving()
    }

    func startObserving(playerItem item: AVPlayerItem) {
        stopObservingLastPlayerItem()

        playerItem = item

        notificationCenter.addObserver(
            self,
            selector: #selector(self.handlePlayToEndTime(_:)),
            name: AVPlayerItem.didPlayToEndTimeNotification,
            object: item
        )
    }

    func stopObservingLastPlayerItem() {
        guard let item = playerItem else {
            return
        }

        playerItem = nil

        notificationCenter.removeObserver(
            self,
            name: AVPlayerItem.didPlayToEndTimeNotification,
            object: item
        )
    }

    func stopObserving() {
        notificationCenter.removeObserver(self)
    }

    @objc private func handlePlayToEndTime(_ playerItem: AVPlayerItem) {
        delegate?.playerItemPlayToEndTime(playerItem)
    }
}

extension AVPlayerItemNotificationObserver {

    protocol Delegate: AnyObject {

        func playerItemPlayToEndTime(_ playerItem: AVPlayerItem)
    }
}
