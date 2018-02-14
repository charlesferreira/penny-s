//
//  SavingAccountListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

final class SavingAccountListViewModel: ViewModel {
    
    private var vms: [SavingAccountViewModel] = []
    
    subscript(i: Int) -> SavingAccountViewModel {
        return vms[i]
    }
    
    var count: Int {
        return vms.count
    }
    
    func observeCollection() {
        db.collection("saving-accounts").order(by: "name").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de reservas: \(error!)")
            }
            
            self.vms = snapshot.documents.flatMap {
                SavingAccountViewModel(documentID: $0.documentID, data: $0.data())
            }
            self.delegate?.viewModelDidChange?()
        }
    }
}

