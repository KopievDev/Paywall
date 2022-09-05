//
//  SubscribeButtonCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

final class SubscribeButtonCell: ReusableCell {
    @IBOutlet var buttonsStack: UIStackView!
    var action: IndexBlock?
    override func render(data: Cell) {
        buttonsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let config = data.data
        action = config[.action] as? IndexBlock
        config[ad: .buttons]
            .map { SubscribeView(text: $0[s: .text], isSelected: $0[b: .selected]) }.enumerated()
            .forEach {
                buttonsStack.addArrangedSubview($0.element)
                $0.element.buttom.tag = $0.offset
                $0.element.buttom.addTarget(self, action: #selector(didTap(button:)), for: .touchUpInside)
            }
    }
    
    @objc func didTap(button: UIButton) {
        action?(button.tag)
        buttonsStack.arrangedSubviews.forEach { view in
            (view as? SubscribeView)?.isSelected = (view as? SubscribeView)?.buttom == button
        }
    }
}

