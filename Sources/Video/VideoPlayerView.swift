//
//  VideoPlayerView.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import UIKit

open class VideoPlayerView<V: VideoAssociation>: UIView {

    public typealias VideoPlayer = V

    private var contentView: VideoPlayer.ContentView

    private var _player: VideoPlayer?
    public var player: VideoPlayer? {
        get { _player }
        set {
            _player?.dissociate(from: contentView)
            _player = nil

            if let player = newValue {
                player.associate(with: contentView)
                _player = player
            }
        }
    }

    public override init(frame: CGRect = .zero) {
        self.contentView = VideoPlayer.ContentView()

        super.init(frame: frame)

        makeUI()
    }

    public init(frame: CGRect = .zero, player: VideoPlayer) {
        self.contentView = VideoPlayer.ContentView()

        super.init(frame: frame)

        self.player = player

        makeUI()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeUI() {
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
