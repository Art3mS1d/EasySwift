//
//  AttributedString.swift
//  EasySwift
//
//  Created by Artem Sydorenko on 09.04.2020.
//

import UIKit

public typealias AttributedString = NSMutableAttributedString


extension AttributedString {
    
    public convenience init(_ str: String = "") {
        self.init(string: str)
    }
    
    public func append(_ image: UIImage, inset: UIEdgeInsets = .zero) -> Self {
        let attachment = NSTextAttachment()
        attachment.image = image
        if inset != .zero {
            attachment.bounds = CGRect(origin: .zero, size: image.size).inset(by: inset)
        }
        append(NSAttributedString(attachment: attachment))
        return self
    }
    
    public func with(_ attribute: NSAttributedString.Key, _ value: Any, _ range: NSRange? = nil) -> Self {
        addAttributes([attribute: value], range: range ?? NSRange(location: 0, length: length))
        return self
    }
    
    public func with(color: UIColor) -> Self {
        with(.foregroundColor, color)
    }
    public func with(font: UIFont) -> Self {
        with(.font, font)
    }
    public func with(link: String, for text: String) -> Self {
        with(.link, link, mutableString.range(of: text))
    }
    public func with(underline: NSUnderlineStyle) -> Self {
        with(.underlineStyle, underline.rawValue)
    }
    
    func with(replacedFonts replaces: [String: String]) -> Self {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { font, range, _ in
            guard let font = font as? UIFont, let next = replaces[font.fontName] else { return }
            removeAttribute(.font, range: range)
            addAttribute(.font, value: UIFont(name: next, size: font.pointSize)!, range: range)
        }
        return self
    }
    
    func with(scale: CGFloat) -> Self {
        enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { font, range, _ in
            guard let font = font as? UIFont else { return }
            removeAttribute(.font, range: range)
            addAttribute(.font, value: font.withSize(font.pointSize * scale), range: range)
        }
        return self
    }
    
    public func with(link: URL, for text: String, attrs: [NSAttributedString.Key: Any]) -> Self {
        with(.link, link, mutableString.range(of: text))
    }
    
    func with(attrs: [NSAttributedString.Key: Any], for texts: [String]) -> Self {
        let string = mutableString
        texts.forEach {
            for range in string.ranges(of: $0) {
                addAttributes(attrs, range: range)
            }
        }
        return self
    }
}

public func + (l: AttributedString, r: AttributedString) -> AttributedString {
    AttributedString(attributedString: l) ~ { $0.append(r) }
}


extension String {
    
    var attributed: AttributedString {
        AttributedString(self)
    }
}
extension NSAttributedString {
    
    var mutable: AttributedString {
        AttributedString(attributedString: self)
    }
}

extension NSString {
    func ranges(of substring: String) -> [NSRange] {
        var ranges: [NSRange] = []
        while ranges.last.map({ $0.upperBound < length }) ?? true {
            let start = ranges.last?.upperBound ?? 0
            let range = self.range(of: substring, range: NSRange(location: start, length: length - start))
            if range.length == 0 { break }
            ranges.append(range)
        }
        return ranges
    }
}
