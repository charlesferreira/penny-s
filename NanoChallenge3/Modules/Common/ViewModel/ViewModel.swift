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
    
    init() {
        db = Firestore.firestore()
    }
}
