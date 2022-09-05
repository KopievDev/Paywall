//
//  BoxCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

class BoxCell: ReusableCell {
    
    @IBOutlet var heightCnstr: NSLayoutConstraint!
    @IBOutlet var weightCnstr: NSLayoutConstraint!
    @IBOutlet var boxView: UIView!

    override func render(data: Cell) {
        let config = data.data
        let height = config[gf:"height"]
        let weight = config[gf:"weight"]
        heightCnstr.isActive = false
        weightCnstr.isActive = false
        heightCnstr.constant = height
        weightCnstr.constant = weight
        heightCnstr.isActive = true
        weightCnstr.isActive = true
        boxView.backgroundColor = .init(hexString: config[s:"color"])
        layoutIfNeeded()
    }
}
