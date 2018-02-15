//
//  SavingAccountListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

final class SavingAccountListViewModel: ViewModel {
    
    private (set) var accounts: [SavingAccountViewModel] = []
    
    subscript(i: Int) -> SavingAccountViewModel {
        return accounts[i]
    }
    
    var count: Int {
        return accounts.count
    }
    
    func observeCollection() {
        db.collection("saving-accounts").order(by: "name").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de reservas: \(error!)")
            }
            
            self.accounts = snapshot.documents.flatMap {
                SavingAccountViewModel(documentID: $0.documentID, data: $0.data())
            }
            self.delegate?.viewModelDidChange?(self)
        }
    }
}

