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

extension UIButton {
    
    convenience init(text: String, deeplink: String?) {
        self.init(frame: .zero)
        setTitle(text, for: .normal)
        accessibilityLabel = deeplink
    }
    
    @objc public func animateIn(view: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc public func animateOut(view viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
            viewToAnimate.transform = .identity
        }
    }
    
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateIn(view:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateOut(view:)), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
}

