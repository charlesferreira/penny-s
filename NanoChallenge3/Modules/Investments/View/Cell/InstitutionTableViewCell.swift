//
//  InstitutionTableViewCell.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InstitutionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    func setup(name: String, hue: CGFloat) {
        nameLabel.text = name
        
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        overlayView.backgroundColor?.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        overlayView.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
}

