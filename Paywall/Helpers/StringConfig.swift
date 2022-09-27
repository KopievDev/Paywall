//
//  StringConfig.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

struct StringConfig {
    
    enum Aligment: String {
        case left, center, right
        var paragraph: NSMutableParagraphStyle {
            let paragraph = NSMutableParagraphStyle()
            switch self {
            case .left: paragraph.alignment = .left
            case .center: paragraph.alignment = .center
            case .right: paragraph.alignment = .right
            }
            return paragraph
        }
    }
    
    var string: NSMutableAttributedString
    var color: UIColor = .black
    var font: UIFont = .systemFont(ofSize: 12)
    var backgroundColor: UIColor = .clear
    var withUnderline: Bool
    var myShadow: NSShadow?
    var alignment: Aligment?
    
    init(text: String, color: UIColor = .black, backgroundColor: UIColor = .clear, font: UIFont = .systemFont(ofSize: 12), withUnderline: Bool = false, myShadow: NSShadow? = nil) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.font = font
        self.withUnderline = withUnderline
        self.myShadow = myShadow
        self.string = NSMutableAttributedString(string: text)
    }
    
    init(_ raw: [String:Any]) {
        string = NSMutableAttributedString(string: raw[s: .text])
        if let color = raw[s0:.textColor] { self.color = .init(hexString: color) }
        if let font = UIFont.Font(rawValue: raw[s:.font]) { self.font =  UIFont.font(type: font, size: raw[gf: .size]) }
        if let backgroundColor = raw[s0: .background] { self.backgroundColor = UIColor(hexString: backgroundColor) }
        withUnderline = raw[b: .withUnderline]
        if let shadow = raw[d0: .shadow] {
            let myShadow = NSShadow()
            myShadow.shadowBlurRadius = shadow[gf: .radius]
            myShadow.shadowOffset = CGSize(width: shadow[gf: .width], height:shadow[gf: .height]) //3x3
            myShadow.shadowColor = UIColor(hexString: shadow[s: .color])
            self.myShadow = myShadow
        }
        if let aligment = Aligment(rawValue: raw[s:"aligment"]) { self.alignment = aligment }
    }
    
    func getAttributedString() -> NSAttributedString {
        var myAttribute: [NSAttributedString.Key : NSObject] = [.foregroundColor: color,
                                                                .backgroundColor: backgroundColor,
                                                                .font: font ]
        if let myShadow = myShadow { myAttribute[.shadow] = myShadow }
        if let alignment = alignment { myAttribute[.paragraphStyle] = alignment.paragraph }
        string.addAttributes(myAttribute, range: NSRange(location: 0, length: string.length))
        if withUnderline {
            string.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue ], range: NSRange(location: 0, length: string.length))
        }
        return string
    }
}

