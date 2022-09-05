//
//  StringConfig.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

struct StringConfig {
    internal init(text: String, color: UIColor = .black, backgroundColor: UIColor = .clear, font: UIFont = .systemFont(ofSize: 12), withUnderline: Bool = false, myShadow: NSShadow? = nil) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.font = font
        self.withUnderline = withUnderline
        self.myShadow = myShadow
        self.string = NSMutableAttributedString(string: text)
    }
    
    var color: UIColor
    var backgroundColor: UIColor
    var font: UIFont
    var withUnderline: Bool
    var myShadow: NSShadow?
    var string: NSMutableAttributedString
    
    func getAttributedString() -> NSAttributedString {
        
        var myAttribute = [ NSAttributedString.Key.foregroundColor: color,
                            NSAttributedString.Key.backgroundColor: backgroundColor,
                            NSAttributedString.Key.font: font ]
        
        if let myShadow = myShadow { myAttribute[NSAttributedString.Key.shadow] = myShadow }
        string.addAttributes(myAttribute, range: NSRange(location: 0, length: string.length))
        if withUnderline {
            string.addAttributes([ NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ], range: NSRange(location: 0, length: string.length))
        }
        return string
    }
}
