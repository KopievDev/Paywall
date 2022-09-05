//
//  ReusableCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

class ReusableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    func render(data: Cell) { }
    func setUp() {}
    
    override func prepareForReuse() {
        subviews.forEach { view in
            (view as? UILabel)?.text = nil
            (view as? UILabel)?.attributedText = nil
            (view as? UIImageView)?.image = nil
        }
    }
}

