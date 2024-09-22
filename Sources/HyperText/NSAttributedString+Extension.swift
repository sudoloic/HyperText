//
//  NSAttributedString+Extension.swift
//  HyperText
//
//  Created by Loïc Salanon on 22/09/2024.
//

import Foundation
import UIKit

extension NSAttributedString {
    convenience init?(html: String, removeLinks: Bool = true) {
        guard let data = html.data(using: .utf8) else {
            return nil
        }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let mutableAttributedString = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) {
            if removeLinks {
                //Remove links
                mutableAttributedString.enumerateAttributes(in: NSRange(location: 0, length: mutableAttributedString.length), options: []) { attributes, range, stop in
                    mutableAttributedString.removeAttribute(.link, range: range)
                    mutableAttributedString.removeAttribute(.underlineStyle, range: range)
                }
            }
            
            // Apply default font and default color
            mutableAttributedString.addAttributes([.foregroundColor: UIColor.label,
                                                   .font: UIFont.preferredFont(forTextStyle: .body)],
                                                  range: NSRange(location: 0, length: mutableAttributedString.length))
            
            
            self.init(attributedString: mutableAttributedString)
        } else {
            return nil
        }
    }
}
