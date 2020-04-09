//
//  AttributedString.swift
//  EasySwift
//
//  Created by Artem Sydorenko on 09.04.2020.
//

import UIKit


typealias AttributedString = NSMutableAttributedString

extension AttributedString {
    
    convenience init(_ str: String = "") {
        self.init(string: str)
    }
    
    func append(_ image: UIImage, inset: UIEdgeInsets = .zero) -> Self {
        let attachment = NSTextAttachment()
        attachment.image = image
        if inset != .zero {
            attachment.bounds = CGRect(origin: .zero, size: image.size).inset(by: inset)
        }
        append(NSAttributedString(attachment: attachment))
        return self
    }
    
    func with(_ attribute: NSAttributedString.Key, _ value: Any, _ range: NSRange? = nil) -> Self {
        addAttributes([attribute: value], range: range ?? NSRange(location: 0, length: length))
        return self
    }
    
    func with(color: UIColor) -> Self {
        with(.foregroundColor, color)
    }
    func with(font: UIFont) -> Self {
        with(.font, font)
    }
    func with(link: String, for text: String) -> Self {
        with(.link, link, mutableString.range(of: text))
    }
}

func + (l: AttributedString, r: AttributedString) -> AttributedString {
    AttributedString(attributedString: l) ~ { $0.append(r) }
}
