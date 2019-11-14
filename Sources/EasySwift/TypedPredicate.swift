//
//  TypedPredicate.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import Foundation

public protocol TypedPredicate: NSPredicate { associatedtype Root }
public class TypedCompoundPredicate<Root>: NSCompoundPredicate, TypedPredicate {}
public class TypedComparisonPredicate<Root>: NSComparisonPredicate, TypedPredicate {}

public func &&<TP1: TypedPredicate, TP2: TypedPredicate>(p1: TP1, p2: TP2) -> TypedCompoundPredicate<TP1.Root> where TP1.Root == TP2.Root {
    TypedCompoundPredicate(type: .and, subpredicates: [p1, p2])
}

public func ||<TP1: TypedPredicate, TP2: TypedPredicate>(p1: TP1, p2: TP2) -> TypedCompoundPredicate<TP1.Root> where TP1.Root == TP2.Root {
    TypedCompoundPredicate(type: .or, subpredicates: [p1, p2])
}

prefix public func !<TP: TypedPredicate>(p: TP) -> TypedCompoundPredicate<TP.Root> {
    TypedCompoundPredicate(type: .not, subpredicates: [p])
}

public func == <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> TypedComparisonPredicate<R> {
    TypedComparisonPredicate(kp, .equalTo, value)
}

public func == <E: Equatable, R, K: KeyPath<R, E?>>(kp: K, value: E) -> TypedComparisonPredicate<R> {
    TypedComparisonPredicate(kp, .equalTo, value)
}

public func != <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> TypedComparisonPredicate<R> {
    TypedComparisonPredicate(kp, .notEqualTo, value)
}

public func > <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    TypedComparisonPredicate(kp, .greaterThan, value)
}

public func < <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    TypedComparisonPredicate(kp, .lessThan, value)
}

public func <= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    TypedComparisonPredicate(kp, .lessThanOrEqualTo, value)
}

public func >= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> TypedComparisonPredicate<R> {
    TypedComparisonPredicate(kp, .greaterThanOrEqualTo, value)
}

public func ~= <S: Sequence, R, K: KeyPath<R, S.Element>>(kp: K, values: S) -> TypedComparisonPredicate<R> where S.Element: Equatable {
    TypedComparisonPredicate(kp, .in, values)
}

public func ~= <S: Sequence, R, K: KeyPath<R, S.Element?>>(kp: K, values: S) -> TypedComparisonPredicate<R> where S.Element: Equatable {
    TypedComparisonPredicate(kp, .in, values)
}

fileprivate extension TypedComparisonPredicate {
    convenience init<Value>(_ kp: KeyPath<Root, Value>, _ op: NSComparisonPredicate.Operator, _ value: Any?) {
        let ex1 = \Root.self == kp ? NSExpression.expressionForEvaluatedObject() : NSExpression(forKeyPath: kp)
        let ex2 = NSExpression(forConstantValue: value)
        self.init(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
}

extension Sequence {
    public func filter<P: TypedPredicate>(_ predicate: P) -> [Element] where P.Root == Element {
        filter(predicate.evaluate)
    }
    
    public func contains<P: TypedPredicate>(_ predicate: P) -> Bool where P.Root == Element {
        contains(where: predicate.evaluate)
    }
}
