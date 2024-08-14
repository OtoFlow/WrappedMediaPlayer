//
//  VideoPlayerView.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import UIKit

open class VideoPlayerView: UIView {

    private var contentView: VideoPlayerContentView

    public private(set) var player: MediaPlayer?

    public init(frame: CGRect = .zero, configuration: MediaPlayer.Configuration) {
        contentView = configuration.engine.createContentView()

        super.init(frame: frame)

        makeUI()
        setupVideoPlayer(with: configuration)
    }

    public init(frame: CGRect = .zero, player: MediaPlayer) {
        contentView = player.configuration.engine.createContentView()

        super.init(frame: frame)

        makeUI()
        setupMediaPlayer(player)
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

    open func setupMediaPlayer(_ videoPlayer: MediaPlayer) {
        player?.stop()
        player = nil

        videoPlayer.wire(to: contentView)

        player = videoPlayer

        videoPlayer.play()
    }

    open func setupVideoPlayer(with configuration: MediaPlayer.Configuration) {
        player?.stop()
        player = nil

        let player = MediaPlayer(configuration: configuration)
        player.wire(to: contentView)

        self.player = player

        player.play()
    }
}
