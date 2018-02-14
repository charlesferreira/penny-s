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
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressViewWidthConstraint: NSLayoutConstraint!
    
    func setup(viewModel vm: SavingAccountViewModel) {
        nameLabel.text = vm.name
        updateBackgroundTint(hue: CGFloat(vm.hue))
        updateProgressView(hue: CGFloat(vm.hue), progress: CGFloat(vm.balance / vm.goal))
    }
    
    func updateBackgroundTint(hue: CGFloat) {
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        backgroundTint.backgroundColor?.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        backgroundTint.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func updateProgressView(hue: CGFloat, progress: CGFloat) {
        // tint
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        progressView.backgroundColor?.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        progressView.backgroundColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        
        // progress
        let fullWidth = progressView.superview!.frame.size.width
        let partialWidth = fullWidth * min(1, progress)
        progressViewWidthConstraint.constant = 0
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.8) {
            self.progressViewWidthConstraint.constant = partialWidth
            self.layoutIfNeeded()
        }
    }
}


