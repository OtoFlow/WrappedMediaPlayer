//
//  ObserverCompatible.swift
//  OtoFlow
//
//  Created by foyoodo on 2024/8/8.
//  Copyright © 2024 foyoodo. All rights reserved.
//

import Foundation

protocol ObserverCompatible {

}

extension ObserverCompatible where Self: NSObject {

    func addObserver<Property>(_ observer: NSObject, for keyPath: KeyPath<Self, Property>, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer? = nil) {
        addObserver(observer, forKeyPath: keyPath.keyPathString, options: options, context: context)
    }

    func removeObserver<Property>(_ observer: NSObject, for keyPath: KeyPath<Self, Property>) {
        removeObserver(observer, forKeyPath: keyPath.keyPathString)
    }
}

extension NSObject: ObserverCompatible { }
