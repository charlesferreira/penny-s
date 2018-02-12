//
//  ViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase

class ViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    let db: Firestore
    
    var documentID: String?
    var isDirty: Bool = false
    
    init() {
        db = Firestore.firestore()
    }
    
    func persist(data: [String: Any], toCollection path: String, completion: ((Error?) -> Void)?) {
        guard isDirty else { return }

        isDirty = false
        
        if let documentID = documentID {
            db.collection(path).document(documentID).setData(data, completion: completion)
        } else {
            db.collection(path).addDocument(data: data, completion: completion)
        }
    }
}
