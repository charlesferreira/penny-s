//
//  AccountEntryViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 14/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

class AccountEntryViewModel: ViewModel {
    
    private var entry: AccountEntry
    
    override var documentID: String? {
        get { return entry.documentID }
        set { entry.documentID = newValue }
    }
    
    var date: Date {
        return entry.date
    }
    
    var value: Double {
        return entry.value
    }
    
    convenience init(documentID: String, data: [String: Any]) {
        self.init(entry: AccountEntry(documentID: documentID, data: data)!)
    }
    
    convenience override init() {
        self.init(entry: AccountEntry())
    }
    
    init(entry: AccountEntry) {
        self.entry = entry
    }
    
    func persist() {
        isDirty = true
        super.persist(data: entry.data, toCollection: "account-entries") { error in
            guard error == nil else {
                self.delegate?.viewModelDidNotPersistData?(self)
                return
            }
            self.delegate?.viewModelDidPersistData?(self)
        }
    }
    
}
