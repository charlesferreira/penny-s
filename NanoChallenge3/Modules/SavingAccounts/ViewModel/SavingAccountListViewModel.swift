//
//  SavingAccountListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

final class SavingAccountListViewModel: ViewModel {
    
    private var savingAccounts: [SavingAccount] = []
    
    var numberOfSavingAccounts: Int {
        return savingAccounts.count
    }
    
    func documentID(forSavingAccountAtIndex index: Int) -> String? {
        return savingAccounts[index].documentID
    }
    
    func name(forSavingAccountAtIndex index: Int) -> String {
        return savingAccounts[index].name
    }
    
    func hue(forSavingAccountAtIndex index: Int) -> Float {
        return savingAccounts[index].hue
    }
    
    func goal(forSavingAccountAtIndex index: Int) -> Double {
        return savingAccounts[index].goal
    }
    
    func balance(forSavingAccountAtIndex index: Int) -> Double {
        return savingAccounts[index].balance
    }
    
    func observeSavingAccountList() {
        db.collection("saving-accounts").order(by: "name").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de reservas: \(error!)")
            }
            
            self.savingAccounts = snapshot.documents.flatMap { SavingAccount(documentID: $0.documentID, data: $0.data()) }
            self.delegate?.viewModelDidChange?()
        }
    }
    
}

