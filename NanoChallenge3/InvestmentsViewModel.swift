//
//  InvestmentsViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 09/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase

struct InvestmentsViewModel {
    
    weak var delegate: ViewModelDelegate?
    
    let db: DocumentReference!
    
    var investments: [Investment]!
    
    init() {
        
    }
    
}
