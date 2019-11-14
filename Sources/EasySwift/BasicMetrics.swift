//
//  BasicMetrics.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import Foundation

// Bytes

extension Double {
    public var KB: Int {
        Int(self * 1024)
    }
    public var MB: Int {
        Int(KB * 1024)
    }
    public var GB: Int {
        Int(MB * 1024)
    }
}

// TimeInterval

extension Double {
    public var seconds: TimeInterval {
        self
    }
    public var minutes: TimeInterval {
        60 * seconds
    }
    public var hours: TimeInterval {
        60 * minutes
    }
    public var days: TimeInterval {
        24 * hours
    }
}
