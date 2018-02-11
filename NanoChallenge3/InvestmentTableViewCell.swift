//
//  InvestmentTableViewCell.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 09/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InvestmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var investment: Investment!
    
    func layout(for investment: Investment) {
        self.investment = investment
    }
    
}
