//
//  NowPlayingInfoController.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 2024/9/10.
//

import MediaPlayer

open class NowPlayingInfoController {

    private let infoCenter = MPNowPlayingInfoCenter.default()

    private var nowPlayingInfo: [String: Any]?

    private let _lock = NSRecursiveLock()

    private weak var lastUpdater: Updater?

    public var playbackState: MPNowPlayingPlaybackState {
        get { infoCenter.playbackState }
        set { infoCenter.playbackState = newValue }
    }

    open var updater: Updater {
        if let lastUpdater {
            return lastUpdater
        }
        let updater = Updater(self)
        lastUpdater = updater
        return updater
    }

    private func synchronize<T>(_ closure: () -> (T)) -> T {
        _lock.lock()
        defer { _lock.unlock() }
        return closure()
    }

    private func update(_ propertyName: String, value: Any) {
        synchronize {
            if nowPlayingInfo == nil {
                nowPlayingInfo = [:]
            }
            nowPlayingInfo![propertyName] = value
        }
    }

    private func clear() {
        synchronize {
            nowPlayingInfo = nil
        }
    }

    private func apply() {
        infoCenter.nowPlayingInfo = nowPlayingInfo
    }
}

extension NowPlayingInfoController {

    public class Updater {

        private var isApplied = true

        private let controller: NowPlayingInfoController

        deinit {
            apply()
        }

        fileprivate init(_ controller: NowPlayingInfoController) {
            self.controller = controller
        }

        @discardableResult
        public func update<Value>(_ property: NowPlayingInfoProperty<Value>, value: Value) -> Self {
            controller.update(property.name, value: value)
            isApplied = false
            return self
        }

        @discardableResult
        public func clear() -> Self {
            controller.clear()
            isApplied = false
            return self
        }

        public func apply() {
            guard !isApplied else { return }
            controller.apply()
            isApplied = true
        }
    }
}
