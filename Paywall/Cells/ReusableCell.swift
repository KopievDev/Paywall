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

class ImageTitleCell: ReusableCell {
    
    enum ImageType: String {
        case ads, saving, tracking, popup, password
        var imageName: String { "icon_\(rawValue)" }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imgView: UIImageView!

    override func render(data: Cell) {
        let raw = data.data
        if let type = ImageType(rawValue: raw[s: .image]) {
            imgView.image = UIImage(named: type.imageName)
        } else {
            imgView.setImage(urlString: raw[s: .image])
        }
        
        titleLabel.text = raw[s: .text]
    }
}
