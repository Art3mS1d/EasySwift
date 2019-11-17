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
public final class Observable<T> {

    public final class WrappedObserver<T>: Observer<T> {
        @usableFromInline weak var delegate: Observable<T>!

        @inlinable override public func observe(_ handler: @escaping (T) -> Void) -> Observation {
            defer { handler(delegate.wrappedValue) }
            return super.observe(handler)
        }
    }

    public let projectedValue = WrappedObserver<T>()

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        self.projectedValue.delegate = self
    }

    public var wrappedValue: T {
        didSet {
            projectedValue.notify(wrappedValue)
        }
    }
}

@usableFromInline struct Descriptor<T> {
    
    @usableFromInline let handler: (T) -> Void
    weak var observation: Observation?

    @usableFromInline init(_ observation: Observation, _ handler: @escaping (T) -> Void) {
        self.observation = observation
        self.handler = handler
    }
}

public final class Observation {

    fileprivate weak var delegate: ObservationDelegate?
    @usableFromInline init(delegate: ObservationDelegate) {
        self.delegate = delegate
    }

    deinit {
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
