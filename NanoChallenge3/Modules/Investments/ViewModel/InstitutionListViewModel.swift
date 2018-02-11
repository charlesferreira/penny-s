//
//  InstitutionListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase

final class InstitutionListViewModel: ViewModel {
    
    private var institutions: [Institution] = []
    
    var numberOfInstitutions: Int {
        return institutions.count
    }
    
    func loadInstitutionList() {
        db.collection("institutions").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                fatalError("Erro ao obter lista de instituições: \(error!)")
            }
            
            self.institutions = snapshot.documents.flatMap { Institution(data: $0.data()) }
            self.delegate?.viewModelDidChange?()
        }
    }
    
    func name(forInstitutionAtIndex index: Int) -> String {
        return institutions[index].name
    }
    
    func hue(forInstitutionAtIndex index: Int) -> Float {
        return institutions[index].hue
    }
    
}
