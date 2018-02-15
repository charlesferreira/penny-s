//
//  AccountEntry.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 10/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

struct AccountEntry {
    
    var documentID: String?
    var accountID: String = ""
    var accountType: AccountType!
    var date: Date = Date()
    var value: Double = 0
    var note: String = ""
}

extension AccountEntry: DocumentSerializable {
    
    init?(documentID: String, data: [String : Any]) {
        guard let accountID = data["accountID"] as? String,
            let accountType = data["accountType"] as? String,
            let date = data["date"] as? Date,
            let value = data["value"] as? Double,
            let note = data["note"] as? String else { return nil }
        
        self.init(documentID: documentID,
                  accountID: accountID,
                  accountType: AccountType(rawValue: accountType),
                  date: date,
                  value: value,
                  note: note)
    }
    
    var data: [String : Any] {
        return [
            "accountID": accountID,
            "accountType": accountType.rawValue,
            "date": date,
            "value": value,
            "note": note
        ]
    }
}

