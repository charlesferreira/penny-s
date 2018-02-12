//
//  SavingAccountViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

final class SavingAccountViewModel: ViewModel {
    
    private (set) var savingAccount: SavingAccount
    
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
    
    var goal: Double {
        get { return savingAccount.goal }
        set {
            savingAccount.goal = newValue
            isDirty = true
        }
    }
    
    var balance: Double {
        get { return savingAccount.balance }
        set {
            savingAccount.balance = newValue
            isDirty = true
        }
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
                self.delegate?.viewModelDidNotPersistData?()
                return
            }
            
            self.delegate?.viewModelDidCreateDocument?()
        }
    }
    
    func validate() -> Bool {
        return !name.isEmpty
    }
}
