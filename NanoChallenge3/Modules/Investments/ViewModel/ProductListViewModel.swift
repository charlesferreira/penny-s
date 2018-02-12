//
//  ProductListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

final class ProductListViewModel: ViewModel {
    
    private var products: [Product] = []
    
    var numberOfProducts: Int {
        return products.count
    }
    
    func documentID(forProductAtIndex index: Int) -> String? {
        return products[index].documentID
    }
    
    func name(forProductAtIndex index: Int) -> String {
        return products[index].name
    }
    
    func note(forProductAtIndex index: Int) -> String {
        return products[index].note
    }
    
    func balance(forProductAtIndex index: Int) -> Double {
        return products[index].balance
    }
    
    func observeProductList() {
        db.collection("products").order(by: "name").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de produtos: \(error!)")
            }
            
            self.products = snapshot.documents.flatMap { Product(documentID: $0.documentID, data: $0.data()) }
            self.delegate?.viewModelDidChange?()
        }
    }
    
}

