//
//  Investment.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

struct Investment {
    
    var documentID: String?
    var productID: String = ""
    var purchaseDate: Date = Date()
    var dueDate: Date = Date()
    var interest: String = ""
    var liquidity: String = ""
    var initialValue: Int = 0
    var balance: Int = 0
}

extension Investment: DocumentSerializable {
    
    init?(documentID: String, data: [String : Any]) {
        guard let productID = data["productID"] as? String,
            let purchaseDate = data["purchaseDate"] as? Date,
            let dueDate = data["dueDate"] as? Date,
            let interest = data["interest"] as? String,
            let liquidity = data["liquidity"] as? String,
            let initialValue  = data["initialValue"] as? Int,
            let balance  = data["balance"] as? Int else { return nil }
        
        self.init(
            documentID: documentID,
            productID: productID,
            purchaseDate: purchaseDate,
            dueDate: dueDate,
            interest: interest,
            liquidity: liquidity,
            initialValue: initialValue,
            balance: balance
        )
    }
    
    var data: [String : Any] {
        return [
            "productID": productID,
            "purchaseDate": purchaseDate,
            "dueDate": dueDate,
            "interest": interest,
            "liquidity": liquidity,
            "initialValue": initialValue,
            "balance": balance
        ]
    }
}

