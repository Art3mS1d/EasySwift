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
}

public func + (l: AttributedString, r: AttributedString) -> AttributedString {
    AttributedString(attributedString: l) ~ { $0.append(r) }
}
