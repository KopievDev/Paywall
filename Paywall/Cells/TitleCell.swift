//
//  TitleCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

final class TitleCell: ReusableCell {
    
    @IBOutlet var titleLabel: UILabel!
    var stringConfig: StringConfig = StringConfig(text: "")
    override func render(data: Cell) {
        let config = data.data
        // MARK: - String
        stringConfig = StringConfig(text: config[s: .text])
        stringConfig.color = UIColor(hexString: config[s:.textColor])
        if let font = UIFont.Font(rawValue: config[s:.font]) { stringConfig.font =  UIFont.font(type: font, size: config[gf: .size]) }
        if let backgroundColor = config[s0: .background] { stringConfig.backgroundColor = UIColor(hexString: backgroundColor) }
        stringConfig.withUnderline = config[b: .withUnderline]

        if let shadow = config[d0: .shadow] {
            let myShadow = NSShadow()
            myShadow.shadowBlurRadius = shadow[gf: .radius]
            myShadow.shadowOffset = CGSize(width: shadow[gf: .width], height:shadow[gf: .height]) //3x3
            myShadow.shadowColor = UIColor(hexString: shadow[s: .color])
            stringConfig.myShadow = myShadow
        }
        titleLabel.attributedText = stringConfig.getAttributedString()
    }
}



