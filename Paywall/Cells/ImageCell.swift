//
//  ImageCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

final class ImageCell: ReusableCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var labelsStack: UIStackView!
    
    override func render(data: Cell) {
        let config = data.data
        labelsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let labels = config[.array] as? [String]
        labels?.map(CheckMarkView.init).forEach { labelsStack.addArrangedSubview($0) }
        imgView.setImage(urlString: config[s:.image])
    }
}
