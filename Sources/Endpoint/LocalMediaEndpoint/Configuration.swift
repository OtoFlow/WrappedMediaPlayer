//
//  Configuration.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/7.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation

extension LocalMediaEndpoint {

    public struct Configuration {

        public var audioEngine: Engine

        public var createVideoEngine: Bool

        public var url: URL?

        public init(
            audioEngine engine: Engine = .system,
            createVideoEngine: Bool = false,
            url: URL? = nil
        ) {
            self.audioEngine = engine
            self.createVideoEngine = createVideoEngine
            self.url = url
        }
    }
}
