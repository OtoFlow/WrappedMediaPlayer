//
//  Configuration.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation

extension MediaPlayer {

    public struct Configuration {

        public var engine: Engine

        public var url: URL

        public init(engine: Engine = .mpv, url: URL) {
            self.engine = engine
            self.url = url
        }
    }
}
