//
//  BasicMetrics.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import Foundation

// Bytes

extension Double {
    var KB: Int {
        Int(self * 1024)
    }
    var MB: Int {
        Int(KB * 1024)
    }
    var GB: Int {
        Int(MB * 1024)
    }
}

// TimeInterval

extension Double {
    var seconds: TimeInterval {
        self
    }
    var minutes: TimeInterval {
        60 * seconds
    }
    var hours: TimeInterval {
        60 * minutes
    }
    var days: TimeInterval {
        24 * hours
    }
}
