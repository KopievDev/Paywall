//
//  PaddingLabel.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

@IBDesignable class PaddingLabel: UILabel {
    

    @IBInspectable var topInset: CGFloat = 4.0 {
        didSet { sizeToFit()}
    }
    @IBInspectable var bottomInset: CGFloat = 4.0 {
        didSet { sizeToFit()}
    }
    @IBInspectable var leftInset: CGFloat = 10.0 {
        didSet { sizeToFit()}
    }
    @IBInspectable var rightInset: CGFloat = 10.0 {
        didSet { sizeToFit()}
    }
    
    override var text: String? {
        didSet { sizeToFit() }
    }
    
    func setUp() {
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .init(hexString: "#19963C")
        textColor = .white
        sizeToFit()
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    override func sizeToFit() {
        guard text?.isEmpty == false else {
            frame = .zero
            return
        }
        super.sizeToFit()
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width + leftInset + rightInset, height: frame.height + topInset + bottomInset)
    }
}
