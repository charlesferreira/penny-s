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
    
    func setup(viewModel vm: ProductViewModel) {
        nameLabel.text = vm.name
        noteLabel.text = vm.note
        balanceLabel.text = vm.balance.asCurrency()
        
        noteLabel.isHidden = vm.note.isEmpty
    }
    
}


