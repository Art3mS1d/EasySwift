//
//  Sequence+KeyPath.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

extension Sequence {
    @inlinable public func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        map { $0[keyPath: keyPath] }
    }
    
    @inlinable public func flatMap<T>(_ keyPath: KeyPath<Element, T>) -> [T.Element] where T: Sequence {
        flatMap { $0[keyPath: keyPath] }
    }
    
    @inlinable public func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        compactMap { $0[keyPath: keyPath] }
    }

    @inlinable public func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
    
    @inlinable public func grouped<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [T: [Element]] {
        .init(grouping: self) { $0[keyPath: keyPath] }
    }
    
    @inlinable public func sum<T>(_ keyPath: KeyPath<Element, T>) -> T where T: Numeric {
        reduce(0) { $0 + $1[keyPath: keyPath] }
    }
    @inlinable public func sum<T>(_ keyPath: KeyPath<Element, T?>) -> T where T: Numeric {
        reduce(0) { $0 + ($1[keyPath: keyPath] ?? 0) }
    }
}
