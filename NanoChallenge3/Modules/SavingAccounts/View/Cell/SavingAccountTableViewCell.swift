//
//  SavingAccountTableViewCell.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class SavingAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundTint: UIView!
    
    func setup(name: String, hue: CGFloat, goal: Double, balance: Double) {
        nameLabel.text = name
        
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        backgroundTint.backgroundColor?.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        backgroundTint.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}


