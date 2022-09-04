//
//  SubscribeButtonCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

class SubscribeButtonCell: ReusableCell {
    @IBOutlet var buttonsStack: UIStackView!
    var action: IndexBlock?
    override func render(data: Cell) {
        buttonsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let config = data.data
        action = config["action"] as? IndexBlock
        config[ad: "buttons"]
            .map { SubscribeView(text: $0[s: "text"], isSelected: $0[b: "selected"]) }.enumerated()
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

class SubscribeView: UIView {
    var isSelected = false {
        didSet {
            buttom.isSelected = isSelected
            selectedLabel.isHidden = !isSelected
        }
    }
    @UsesAutoLayout
    var buttom = SubscribeButton(text: "nil", isSelected: false)
    @UsesAutoLayout
    var selectedLabel = PaddingLabel(text: "Best choice")

    init(text: String, isSelected: Bool) {
        super.init(frame: .zero)
        buttom = SubscribeButton(text: text)
        self.isSelected = isSelected
        setUp()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttom)
        addSubview(selectedLabel)
        selectedLabel.isHidden = !isSelected
        buttom.isSelected = isSelected
        NSLayoutConstraint.activate([
            selectedLabel.centerYAnchor.constraint(equalTo:  buttom.topAnchor),
            selectedLabel.centerXAnchor.constraint(equalTo: buttom.centerXAnchor),
            
            buttom.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttom.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttom.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttom.topAnchor.constraint(equalTo: topAnchor, constant: 15)
        ])
    }
}

class SubscribeButton: UIButton {
    
    var selectedColor: UIColor = UIColor(hexString: "#16D077")
    var unselectedColor: UIColor = UIColor(hexString: "#9918FF")
    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? selectedColor.cgColor : unselectedColor.cgColor
        }
    }
    
    init(text: String, isSelected: Bool = false) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        self.isSelected = isSelected
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        layer.borderWidth = 4
    }
}

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
