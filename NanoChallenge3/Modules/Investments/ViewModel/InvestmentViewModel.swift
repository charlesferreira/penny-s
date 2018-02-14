//
//  InvestmentViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

final class InvestmentViewModel: ViewModel {
    
    private var investment: Investment
    
    override var documentID: String? {
        get { return investment.documentID }
        set { investment.documentID = newValue }
    }
    
    var productID: String {
        get { return investment.productID }
        set { investment.productID = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    var purchaseDate: Date {
        get { return investment.purchaseDate }
        set {
            investment.purchaseDate = newValue
            isDirty = true
        }
    }
    
    var dueDate: Date {
        get { return investment.dueDate }
        set {
            investment.dueDate = newValue
            isDirty = true
        }
    }
    
    var interest: String {
        get { return investment.interest }
        set {
            investment.interest = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            isDirty = true
        }
    }
    
    var liquidity: String {
        get { return investment.liquidity }
        set {
            investment.liquidity = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            isDirty = true
        }
    }
    
    var initialValue: Double {
        get { return investment.initialValue }
        set {
            investment.initialValue = newValue
            isDirty = true
        }
    }
    
    var balance: Double {
        get { return investment.balance }
        set {
            investment.balance = newValue
            isDirty = true
        }
    }
    
    convenience override init() {
        self.init(investment: Investment())
    }
    
    init(investment: Investment) {
        self.investment = investment
    }
    
    func persist() {
        super.persist(data: investment.data, toCollection: "investments") { error in
            guard error == nil else {
                self.delegate?.viewModelDidNotPersistData?()
                return
            }
            
            self.delegate?.viewModelDidCreateDocument?()
        }
    }
    
    func validate() -> Bool {
        return !productID.isEmpty && initialValue > 0
    }
}


