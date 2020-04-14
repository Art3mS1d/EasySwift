//
//  UserDefault.swift
//  EasySwift
//
//  Created by Artem Sydorenko on 09.04.2020.
//

import Foundation


@propertyWrapper
public struct UserDefault<Value: PropertyListValue> {
    let key: Key<Value>
    let defaultValue: Value
    let defaults: UserDefaults

    public init(wrappedValue: Value, _ key: Key<Value>, _ defaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = wrappedValue
        self.defaults = defaults
    }

    public var wrappedValue: Value {
        get {
            defaults.object(forKey: key.rawValue) as? Value ?? defaultValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil {
                defaults.removeObject(forKey: key.rawValue)
            } else {
                defaults.set(newValue, forKey: key.rawValue)
            }
        }
    }
    
    public struct Key<Value: PropertyListValue>: RawRepresentable, ExpressibleByStringLiteral {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        public init(stringLiteral: String) {
            rawValue = stringLiteral
        }
    }
}


public protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}

extension Optional: PropertyListValue where Wrapped: PropertyListValue {}


fileprivate protocol OptionalProtocol {
    var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
    var isNil: Bool {
        self == nil
    }
}
