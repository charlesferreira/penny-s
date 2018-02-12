//
//  Product.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct Product {
    
    var documentID: String?
    var name: String = ""
    var note: String = ""
    var balance: Double = 0.0
}

extension Product: DocumentSerializable {
    
    init?(documentID: String, data: [String : Any]) {
        guard let name = data["name"] as? String,
            let note = data["note"] as? String,
            let balance  = data["balance"] as? Double else { return nil }
        
        self.init(documentID: documentID, name: name, note: note, balance: balance)
    }
    
    var data: [String : Any] {
        return [
            "name": name,
            "note": note,
            "balance": balance
        ]
    }
}
