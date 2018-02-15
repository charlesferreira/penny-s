//
//  IncomeAllocationViewModelDelegate.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 14/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

protocol IncomeAllocationViewModelDelegate: AnyObject {
    
    var leftover: Int { get }
    
    func viewModelDidChange(_ viewModel: IncomeAllocationViewModel, tableViewNeedsDataReload: Bool)
    
    func viewModelDidPersistData(_ viewModel: IncomeAllocationViewModel)
}
