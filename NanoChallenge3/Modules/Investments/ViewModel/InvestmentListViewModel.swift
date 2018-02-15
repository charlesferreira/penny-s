//
//  InvestmentListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 13/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

final class InvestmentListViewModel: ViewModel {
    
    private var investments: [InvestmentViewModel] = []
    
    subscript(i: Int) -> InvestmentViewModel {
        return investments[i]
    }
    
    var count: Int {
        return investments.count
    }
    
    func observeCollection(forProductID productID: String) {
        db.collection("investments").whereField("productID", isEqualTo: productID).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de investimentos: \(error!)")
            }
            
            self.investments = snapshot.documents.flatMap {
                InvestmentViewModel(documentID: $0.documentID, data: $0.data())
            }
            self.delegate?.viewModelDidChange?(self)
        }
    }
    
}


