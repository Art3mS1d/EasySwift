//
//  Observable.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import Foundation

@dynamicCallable
public class Observer<T>: ObservationDelegate {

    public init() { }
    @usableFromInline var descriptors: [Descriptor<T>] = []

    @inlinable public func observe(_ handler: @escaping (T) -> Void) -> Observation {
        let observation = Observation(delegate: self)
        descriptors.append(Descriptor(observation, handler))
        return observation
    }

    @inlinable public func observeOnMain(_ handler: @escaping (T) -> Void) -> Observation {
        observe { t in
            DispatchQueue.main.async {
                handler(t)
            }
        }
    }

    @inlinable public func notify(_ x: T) {
        descriptors.forEach { $0.handler(x) }
    }

    // To notify
    @inlinable public func dynamicallyCall(withArguments values: [T]) {
        values.forEach(notify)
    }

    // To subscribe
    @inlinable public func dynamicallyCall(withArguments handler: [(T) -> Void]) -> Observation {
        observe(handler.first!)
    }

    @usableFromInline func invalidate() {
        descriptors.removeAll { $0.observation == nil }
    }
}

@propertyWrapper
public final class Observable<T>: Observer<T> {

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: T {
        didSet {
            notify(wrappedValue)
        }
    }
    
    public var projectedValue: Observer<T>  {
        self
    }
    
    @inlinable override public func observe(_ handler: @escaping (T) -> Void) -> Observation {
        defer { handler(wrappedValue) }
        return super.observe(handler)
    }
}

@usableFromInline struct Descriptor<T> {
    
    @usableFromInline let handler: (T) -> Void
    @usableFromInline weak var observation: Observation?

    @usableFromInline init(_ observation: Observation, _ handler: @escaping (T) -> Void) {
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
    public func dispose(in bag: inout [Observation]) {
        bag.append(self)
    }

    public func dispose(in bag: inout Observation?) {
        bag = self
    }
}

extension Observer where T == Void {
    func dynamicallyCall(withArguments values: [T]) {
        notify(())
    }
}
