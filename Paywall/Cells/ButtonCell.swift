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
    override func render(data: Cell) {
        let config = data.data
        action = config[.action] as? VoidBlock
        deeplinkAction = config[.deeplinkAction] as? StringBlock
        deeplink = config[s0: .deeplink]
        button.setTitle(config[s: .text], for: .normal)
        button.backgroundColor = .init(hexString: config[s:.color])
        button.setTitleColor(.init(hexString: config[s:.textColor]), for: .normal)
        guard let font = UIFont.Font(rawValue: config[s:.font]) else { return }
        button.titleLabel?.font = UIFont.font(type: font, size: config[.size] as! CGFloat)
        button.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
        button.startAnimatingPressActions()
    }
    
    @objc func didTap(button: UIButton) {
        action?()
        if let deeplink = deeplink {
            deeplinkAction?(deeplink)
        }
    }
}
