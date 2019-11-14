//
//  Observable.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import Foundation

@dynamicCallable
public class Observer<T>: ObservationDelegate {

    fileprivate var descriptors: [Descriptor<T>] = []

    func observe(_ handler: @escaping (T) -> Void) -> Observation {
        let observation = Observation(delegate: self)
        descriptors.append(Descriptor(observation, handler))
        return observation
    }

    func observeOnMain(_ handler: @escaping (T) -> Void) -> Observation {
        observe { t in
            DispatchQueue.main.async {
                handler(t)
            }
        }
    }

    func notify(_ x: T) {
        descriptors.forEach { $0.handler(x) }
    }

    // To notify
    func dynamicallyCall(withArguments values: [T]) {
        values.forEach(notify)
    }

    // To subscribe
    func dynamicallyCall(withArguments handler: [(T) -> Void]) -> Observation {
        observe(handler.first!)
    }

    fileprivate func invalidate() {
        descriptors.removeAll { $0.observation == nil }
    }
}

@propertyWrapper
public class Observable<T> {

    public class WrappedObserver<T>: Observer<T> {
        fileprivate weak var delegate: Observable<T>!

        override func observe(_ handler: @escaping (T) -> Void) -> Observation {
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

private struct Descriptor<T> {

    let handler: (T) -> Void

    weak var observation: Observation?

    init(_ observation: Observation, _ handler: @escaping (T) -> Void) {
        self.observation = observation
        self.handler = handler
    }
}

public class Observation {

    private weak var delegate: ObservationDelegate?
    fileprivate init(delegate: ObservationDelegate) {
        self.delegate = delegate
    }

    deinit {
        delegate?.invalidate()
    }
}

private protocol ObservationDelegate: class {
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
