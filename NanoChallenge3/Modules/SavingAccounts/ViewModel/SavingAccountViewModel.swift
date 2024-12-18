//
//  SavingAccountViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

final class SavingAccountViewModel: ViewModel {
    
    private var savingAccount: SavingAccount
    
    override var documentID: String? {
        get { return savingAccount.documentID }
        set { savingAccount.documentID = newValue }
    }
    
    var name: String {
        get { return savingAccount.name }
        set {
            savingAccount.name = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            isDirty = true
        }
    }
    
    var hue: Float {
        get { return savingAccount.hue }
        set {
            savingAccount.hue = newValue
            isDirty = true
        }
    }
    
    var goal: Int {
        get { return savingAccount.goal }
        set {
            savingAccount.goal = newValue
            isDirty = true
        }
    }
    
    var balance: Int {
        get { return savingAccount.balance }
        set {
            savingAccount.balance = newValue
            isDirty = true
        }
    }
    
    var summary: String {
        return [
            "Atual: ",
            (10000 * balance / goal).asCurrency(),
            "% de ",
            goal.asCurrency(symbol: "R$ ")
        ].joined()
    }
    
    convenience init(documentID: String, data: [String: Any]) {
        self.init(savingAccount: SavingAccount(documentID: documentID, data: data)!)
    }
    
    convenience override init() {
        self.init(savingAccount: SavingAccount())
    }
    
    init(savingAccount: SavingAccount) {
        self.savingAccount = savingAccount
    }
    
    func persist() {
        super.persist(data: savingAccount.data, toCollection: "saving-accounts") { error in
            guard error == nil else {
                self.delegate?.viewModelDidNotPersistData?(self)
                return
            }
            
            self.delegate?.viewModelDidPersistData?(self)
        }
    }
    
    func validate() -> Bool {
        return !name.isEmpty && goal > 0
    }
}
