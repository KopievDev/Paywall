//
//  LogoCell.swift
//  Paywall
//
//  Created by Ivan Kopiev on 05.09.2022.
//

import UIKit

class LogoCell: ReusableCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var heightCnstr: NSLayoutConstraint!
    @IBOutlet var weightCnstr: NSLayoutConstraint!
    
    override func render(data: Cell) {
        let config = data.data
        imgView.setImage(urlString: config[s:"image"])
       
        if let height = config[gf0:"height"] {
            heightCnstr.constant = height
            heightCnstr.isActive = false
            heightCnstr.isActive = true
        }
        
        if let weight = config[gf0:"weight"] {
            weightCnstr.isActive = false
            weightCnstr.constant = weight
            weightCnstr.isActive = true
        }
    }
}
