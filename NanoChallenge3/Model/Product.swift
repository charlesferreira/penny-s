//
//  Product.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct Product {
    
    var documentID: String?
    var institutionID: String = ""
    var name: String = ""
    var note: String = ""
    var balance: Int = 0
}

extension Product: DocumentSerializable {
    
    init?(documentID: String, data: [String : Any]) {
        guard let institutionID = data["institutionID"] as? String,
            let name = data["name"] as? String,
            let note = data["note"] as? String,
            let balance  = data["balance"] as? Int else { return nil }
        
        self.init(
            documentID: documentID,
            institutionID: institutionID,
            name: name,
            note: note,
            balance: balance)
    }
    
    var data: [String : Any] {
        return [
            "institutionID": institutionID,
            "name": name,
            "note": note,
            "balance": balance
        ]
    }
}
