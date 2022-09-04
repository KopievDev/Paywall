//
//  TitleCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 04.09.2022.
//

import UIKit

class TitleCell: ReusableCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    override func render(data: Cell) {
        let config = data.data
        titleLabel.text = config[s: .text]
        titleLabel.textColor = UIColor(hexString: config[s:.textColor])
        guard let font = UIFont.Font(rawValue: config[s:.font]) else { return }
        titleLabel.font = UIFont.font(type: font, size: config[.size] as! CGFloat)
    }
}

class EmptyCell: ReusableCell {
    @IBOutlet var heightCnstr: NSLayoutConstraint!
    
    override func render(data: Cell) {
        let config = data.data
        let height = config[gf:"height"]
        heightCnstr.isActive = false
        heightCnstr.constant = height
        heightCnstr.isActive = true
        layoutIfNeeded()
    }

}


class ImageCell: ReusableCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var labelsStack: UIStackView!
    
    override func render(data: Cell) {
        let config = data.data
        labelsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let labels = config["array"] as? [String]
        labels?.map(CheckMarkView.init).forEach { labelsStack.addArrangedSubview($0) }
        imgView.setImage(urlString: config[s:"image"])
    }
}

class CheckMarkView: UIView {
    @UsesAutoLayout
    var imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    @UsesAutoLayout
    var labelView = UILabel()
    
    
    init(text: String) {
        super.init(frame: .zero)
        setUp()
        labelView.text = text
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
        addSubview(imageView)
        addSubview(labelView)
        labelView.textColor = .white
        labelView.font = UIFont.systemFont(ofSize: 14)
        imageView.tintColor = UIColor(hexString: "#9105FF")
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            labelView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            labelView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    
}


