//
//  ProductViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

final class ProductViewModel: ViewModel {
    
    private var product: Product
    
    override var documentID: String? {
        get { return product.documentID }
        set { product.documentID = newValue }
    }
    
    var institutionID: String {
        get { return product.institutionID }
        set { product.institutionID = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    var name: String {
        get { return product.name }
        set {
            product.name = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            isDirty = true
        }
    }
    
    var note: String {
        get { return product.note }
        set {
            product.note = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            isDirty = true
        }
    }
    
    var balance: Double {
        get { return product.balance }
        set {
            product.balance = newValue
            isDirty = true
        }
    }
    
    convenience init(documentID: String, data: [String: Any]) {
        self.init(product: Product(documentID: documentID, data: data)!)
    }
    
    convenience override init() {
        self.init(product: Product())
    }
    
    init(product: Product) {
        self.product = product
    }
    
    func persist() {
        super.persist(data: product.data, toCollection: "products") { error in
            guard error == nil else {
                self.delegate?.viewModelDidNotPersistData?(self)
                return
            }
            
            self.delegate?.viewModelDidPersistData?(self)
        }
    }
    
    func validate() -> Bool {
        return !institutionID.isEmpty && !name.isEmpty
    }
}


