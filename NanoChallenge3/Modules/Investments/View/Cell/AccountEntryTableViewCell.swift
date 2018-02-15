//
//  AccountEntryTableViewCell.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 15/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class AccountEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func setup(viewModel vm: AccountEntryViewModel) {
        dateLabel.text = vm.date.toString()
        valueLabel.text = vm.value.asCurrency()
    }
    
}



