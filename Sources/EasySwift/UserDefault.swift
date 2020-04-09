//
//  UserDefault.swift
//  EasySwift
//
//  Created by Artem Sydorenko on 09.04.2020.
//

import Foundation


@propertyWrapper
public struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    let defaults: UserDefaults

    public init(wrappedValue: Value, _ key: String, _ defaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = wrappedValue
        self.defaults = defaults
    }

    public var wrappedValue: Value {
        get {
            defaults.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil {
                defaults.removeObject(forKey: key)
            } else {
                defaults.set(newValue, forKey: key)
            }
        }
    }
}

fileprivate protocol OptionalProtocol {
    var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
    var isNil: Bool {
        self == nil
    }
}

