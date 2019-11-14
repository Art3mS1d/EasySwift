//
//  UIColor+Hex.swift
//  
//
//  Created by Artem Sydorenko on 14.11.2019.
//

import UIKit

extension UIColor {

    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
    }

    convenience init(_ rgb: Int, a: CGFloat = 1) {
        self.init(r: (rgb >> 16) & 0xFF, g: (rgb >> 8) & 0xFF, b: rgb & 0xFF, a: a)
    }

    convenience init?(_ hex: String) {
        var string = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.hasPrefix("#") {
            string.removeFirst()
        }
        guard string.count == 6 else { return nil }
        var rgb: UInt64 = 0
        Scanner(string: string).scanHexInt64(&rgb)
        self.init(Int(rgb))
    }

    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return String(format: "#%02lX%02lX%02lX", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    // shortcut for alpha modifier
    func alpha(_ value: CGFloat) -> UIColor {
        withAlphaComponent(value)
    }
}
