//
//  SavingAccount.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 10/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct SavingAccount {
    
    var documentID: String?
    var name: String = ""
    var hue: Float = 0.0
    var goal: Double = 0.0
    var balance: Double = 0.0
}

extension SavingAccount: DocumentSerializable {
    
    init?(documentID: String, data: [String : Any]) {
        guard let name = data["name"] as? String,
            let hue = data["hue"] as? Float,
            let goal = data["goal"] as? Double,
            let balance = data["balance"] as? Double else { return nil }
        
        self.init(documentID: documentID, name: name, hue: hue, goal: goal, balance: balance)
    }
    
    var data: [String : Any] {
        return [
            "name": name,
            "hue": hue,
            "goal": goal,
            "balance": balance
        ]
    }
}

