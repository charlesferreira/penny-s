//
//  IncomeAllocationTableViewCellDelegate.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 14/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

protocol IncomeAllocationTableViewCellDelegate: AnyObject {
    
    func tableViewCellDidChange(_ cell: IncomeAllocationTableViewCell)
    
    func tableViewCellDidUpdateValue(_ cell: IncomeAllocationTableViewCell)
}
