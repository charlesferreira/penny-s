//
//  InvestmentTableViewCell.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 13/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InvestmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    func setup(viewModel vm: InvestmentViewModel) {
        purchaseDateLabel.text = vm.purchaseDate.toString()
        summaryLabel.text = vm.summary
        balanceLabel.text = vm.balance.asCurrency()
        
        summaryLabel.isHidden = vm.summary.isEmpty
    }
    
}



