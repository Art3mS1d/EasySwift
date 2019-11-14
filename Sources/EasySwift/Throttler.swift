//
//  Throttler.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import Foundation

public class Throttler {
    
    private let minimumDelay: TimeInterval
    private let lock = Lock()
    private let queue: DispatchQueue
    private var workItem = DispatchWorkItem {}
    private var previousRun = Date.distantPast
    
    public init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.minimumDelay = delay
        self.queue = queue
    }
    
    public func throttle(handler: @escaping () -> Void) {
        lock.lock()
        defer { lock.unlock() }
        
        workItem.cancel()
        workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.previousRun = Date()
            handler()
        }
        let next = previousRun + minimumDelay
        if next < Date() {
            queue.async(execute: workItem)
        } else {
            queue.asyncAfter(deadline: .now() + next.timeIntervalSinceNow, execute: workItem)
        }
    }
}

extension Observer {
    
    public func throttle(_ delay: TimeInterval, in queue: DispatchQueue = .main, _ handler: @escaping (T) -> Void) -> Observation {
        let throttler = Throttler(delay: delay, queue: queue)
        return observe { t in
            throttler.throttle {
                handler(t)
            }
        }
    }
}

public final class Lock {
    
    private var mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        return mutex
    }()

    func lock() {
        pthread_mutex_lock(&mutex)
    }

    func unlock() {
        pthread_mutex_unlock(&mutex)
    }
}
