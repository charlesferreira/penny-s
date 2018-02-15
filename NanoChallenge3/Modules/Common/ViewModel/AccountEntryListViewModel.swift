//
//  AccountEntryListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 15/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

final class AccountEntryListViewModel: ViewModel {
    
    private var accounts: [AccountEntryViewModel] = []
    
    subscript(i: Int) -> AccountEntryViewModel {
        return accounts[i]
    }
    
    var count: Int {
        return accounts.count
    }
    
    func observeCollection(forAccountID accountID: String, type: AccountType) {
        db.collection("account-entries")
            .whereField("accountID", isEqualTo: accountID)
            .whereField("accountType", isEqualTo: type.rawValue)
            .addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de registros: \(error!)")
            }
            
            self.accounts = snapshot.documents.flatMap {
                AccountEntryViewModel(documentID: $0.documentID, data: $0.data())
            }
            self.delegate?.viewModelDidChange?(self)
        }
    }
    
}


