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
        titleLabel.text = config[s: .text]
        titleLabel.textColor = UIColor(hexString: config[s:.textColor])
        guard let font = UIFont.Font(rawValue: config[s:.font]) else { return }
        titleLabel.font = UIFont.font(type: font, size: config[.size] as! CGFloat)
    }
}
