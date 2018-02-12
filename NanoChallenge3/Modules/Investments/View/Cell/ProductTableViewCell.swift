//
//  ProductTableViewCell.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    func setup(name: String, note: String, balance: Double) {
        nameLabel.text = name
        noteLabel.text = note
        balanceLabel.text = balance.asCurrency()
        
        noteLabel.isHidden = note.isEmpty
    }
    
}


