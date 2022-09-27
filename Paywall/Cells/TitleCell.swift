//
//  TitleCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

final class TitleCell: ReusableCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    override func render(data: Cell) {
        let config = data.data
        titleLabel.attributedText = StringConfig(config).getAttributedString()
    }
}



