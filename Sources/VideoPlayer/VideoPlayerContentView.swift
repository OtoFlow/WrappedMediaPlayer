//
//  VideoPlayerContentView.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/8.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import UIKit
import AVFoundation
import MPVPlayer

class VideoPlayerContentView: UIView {

}

class AVPlayerContentView: VideoPlayerContentView {

    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    private var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
}

class MPVPlayerContentView: VideoPlayerContentView {

    override class var layerClass: AnyClass {
        MetalLayer.self
    }

    var metalLayer: MetalLayer {
        layer as! MetalLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        metalLayer.contentsScale = UIScreen.main.nativeScale
        metalLayer.framebufferOnly = true
        metalLayer.backgroundColor = UIColor.black.cgColor
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
