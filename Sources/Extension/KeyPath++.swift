//
//  KeyPath++.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/8.
//  Copyright © 2024 foyoodo. All rights reserved.
//
//  Reference: https://github.com/JohnEstropia/CoreStore/blob/develop/Sources/KeyPath%2BKeyPaths.swift
//

extension KeyPath {

    var keyPathString: String {
//        return NSExpression(forKeyPath: self).keyPath // in case _kvcKeyPathString becomes private API
        return self._kvcKeyPathString!
    }
}
