//
//  ProductListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

final class ProductListViewModel: ViewModel {
    
    private var products: [ProductViewModel] = []
    
    subscript(i: Int) -> ProductViewModel {
        return products[i]
    }
    
    var count: Int {
        return products.count
    }
    
    func observeCollection(forInstitutionID institutionID: String) {
        db.collection("products").whereField("institutionID", isEqualTo: institutionID).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de produtos: \(error!)")
            }
            
            self.products = snapshot.documents.flatMap {
                ProductViewModel(documentID: $0.documentID, data: $0.data())
            }
            self.delegate?.viewModelDidChange?(self)
        }
    }
    
}

