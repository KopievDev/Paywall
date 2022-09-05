//
//  TermsCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

class TermsCell: ReusableCell {
    
    @IBOutlet var buttonsStack: UIStackView!
    var action: IndexBlock?
    var deeplinkAction: StringBlock?

    override func render(data: Cell) {
        buttonsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let config = data.data
        action = config["action"] as? IndexBlock
        deeplinkAction = config["deeplinks"] as? StringBlock

        config[ad: "buttons"]
            .map { UIButton(text: $0[s: "text"], deeplink: $0[s0:"deeplink"]) }.enumerated()
            .forEach {
                buttonsStack.addArrangedSubview($0.element)
                $0.element.tag = $0.offset
                $0.element.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
            }
    }
    
    @objc func didTap(button: UIButton) {
        action?(button.tag)
        guard let deeplink = button.accessibilityLabel else { return }
        deeplinkAction?(deeplink)
    }
}
