//
//  IncomeAllocationTableViewCellDataSource.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 14/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

protocol IncomeAllocationTableViewCellDataSource: AnyObject {
    
    func tableViewCellNumberOfAccounts(_ cell: IncomeAllocationTableViewCell) -> Int

    func tableViewCell(_ cell: IncomeAllocationTableViewCell, accountNameForRow row: Int) -> String
    
    func tableViewCell(_ cell: IncomeAllocationTableViewCell, tintForAccountAtIndex index: Int) -> Float
    
    func delete(cellAtRow row: Int)

}
