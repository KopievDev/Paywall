//
//  SubscribeView.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

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
        buttom.startAnimatingPressActions()
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
