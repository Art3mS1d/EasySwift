//
//  Observable.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import Foundation

@dynamicCallable
public class Observer<Value>: ObservationDelegate {

    public init() { }
    @usableFromInline var descriptors: [Descriptor<Value>] = []

    @inlinable public func observe(_ handler: @escaping (Value) -> Void) -> Observation {
        let observation = Observation(delegate: self)
        descriptors.append(Descriptor(observation, handler))
        return observation
    }

    @inlinable public func observeOnMain(_ handler: @escaping (Value) -> Void) -> Observation {
        observe { value in
            DispatchQueue.main.async {
                handler(value)
            }
        }
    }

    @inlinable public func notify(_ value: Value) {
        descriptors.forEach { $0.handler(value) }
    }

    // To notify
    @inlinable public func dynamicallyCall(withArguments values: [Value]) {
        values.forEach(notify)
    }

    // To subscribe
    @inlinable public func dynamicallyCall(withArguments handler: [(Value) -> Void]) -> Observation {
        observe(handler.first!)
    }

    @usableFromInline func invalidate() {
        descriptors.removeAll { $0.observation == nil }
    }
}

@propertyWrapper
public final class Observable<Value>: Observer<Value> {

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: Value {
        didSet {
            notify(wrappedValue)
        }
    }
    
    public var projectedValue: Observer<Value>  {
        self
    }
    
    @inlinable override public func observe(_ handler: @escaping (Value) -> Void) -> Observation {
        handler(wrappedValue)
        return super.observe(handler)
    }
}

@usableFromInline final class Descriptor<Value> {
    
    @usableFromInline let handler: (Value) -> Void
    @usableFromInline weak var observation: Observation?

    @usableFromInline init(_ observation: Observation, _ handler: @escaping (Value) -> Void) {
        self.observation = observation
        self.handler = handler
    }
}

public final class Observation {

    @usableFromInline weak var delegate: ObservationDelegate?
    @usableFromInline init(delegate: ObservationDelegate) {
        self.delegate = delegate
    }

    @inlinable deinit {
        delegate?.invalidate()
    }
}

@usableFromInline protocol ObservationDelegate: class {
    func invalidate()
}

extension Observation {
    @inlinable public func dispose(in bag: inout [Observation]) {
        bag.append(self)
    }

    @inlinable public func dispose(in bag: inout Observation?) {
        bag = self
    }
}

extension Observer where Value == Void {
    @inlinable public func notify() {
        notify(())
    }
    @inlinable public func dynamicallyCall(withArguments values: [Void]) {
        notify()
    }
}
