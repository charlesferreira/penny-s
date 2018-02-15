//
//  Institution.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct Institution {
    
    var documentID: String?
    var name: String = ""
    var hue: Float = 0.66
    var balance: Int = 0
}

extension Institution: DocumentSerializable {
    
    init?(documentID: String, data: [String : Any]) {
        guard let name = data["name"] as? String,
            let hue = data["hue"] as? Float,
            let balance = data["balance"] as? Int else { return nil }
        
        self.init(documentID: documentID, name: name, hue: hue, balance: balance)
    }
    
    var data: [String : Any] {
        return [
            "name": name,
            "hue": hue,
            "balance": balance
        ]
    }
}
