//
//  SubscribeButton.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

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
