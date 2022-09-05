//
//  EmptyCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

final class EmptyCell: ReusableCell {
    @IBOutlet var heightCnstr: NSLayoutConstraint!
    
    override func render(data: Cell) {
        let config = data.data
        let height = config[gf: .height]
        heightCnstr.isActive = false
        heightCnstr.constant = height
        heightCnstr.isActive = true
        layoutIfNeeded()
    }
}
