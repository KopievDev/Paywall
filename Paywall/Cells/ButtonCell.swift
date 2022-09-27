//
//  ButtonCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

final class ButtonCell: ReusableCell {
    
    @IBOutlet var button: UIButton!
    var action: VoidBlock?
    var deeplinkAction: StringBlock?
    var deeplink: String?
    var stringConfig: StringConfig = StringConfig(text: "")
    
    override func render(data: Cell) {
        let config = data.data
        action = config[.action] as? VoidBlock
        deeplinkAction = config[.deeplinkAction] as? StringBlock
        deeplink = config[s0: .deeplink]
        button.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
        button.backgroundColor = .init(hexString: config[s:.color])
        set(data: config)
        button.startAnimatingPressActions()
    }
    
    @objc func didTap(button: UIButton) {
        action?()
        if let deeplink = deeplink {
            deeplinkAction?(deeplink)
        }
    }
    
     func set(data: [String:Any]) {
        let config = data
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
        button.setAttributedTitle(stringConfig.getAttributedString(), for: .normal)
    }
}
