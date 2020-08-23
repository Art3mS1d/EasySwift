//
//  UIColor+Hex.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import UIKit

extension UIColor {

    public convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }

    public convenience init(_ rgb: Int, a: CGFloat = 1) {
        self.init(r: (rgb >> 16) & 0xFF, g: (rgb >> 8) & 0xFF, b: rgb & 0xFF, a: a)
    }

    public convenience init?(_ hex: String) {
        var string = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.hasPrefix("#") {
            string.removeFirst()
        }
        guard string.count == 6 else { return nil }
        var rgb: UInt64 = 0
        Scanner(string: string).scanHexInt64(&rgb)
        self.init(Int(rgb))
    }

    public var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return [r, g, b].map { String(format: "%02lX", Int($0 * 255)) }.reduce("#", +)
    }

    // shortcut for alpha modifier
    public func alpha(_ value: CGFloat) -> UIColor {
        withAlphaComponent(value)
    }
}
