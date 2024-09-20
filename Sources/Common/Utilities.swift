//
//  Utilities.swift
//  WrappedMediaPlayer
//
//  Created by foyoodo on 20/9/2024.
//

protocol _OptionalProtocol: ExpressibleByNilLiteral {

    var _isNil: Bool { get }
}

extension Optional: _OptionalProtocol {

    var _isNil: Bool { self == nil }
}
