//
//  CheckMarkView.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

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
