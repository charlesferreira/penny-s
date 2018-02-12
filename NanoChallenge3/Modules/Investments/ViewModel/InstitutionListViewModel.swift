//
//  InstitutionListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

final class InstitutionListViewModel: ViewModel {
    
    private var institutions: [Institution] = []
    
    var numberOfInstitutions: Int {
        return institutions.count
    }
    
    func documentID(forInstitutionAtIndex index: Int) -> String? {
        return institutions[index].documentID
    }
    
    func name(forInstitutionAtIndex index: Int) -> String {
        return institutions[index].name
    }
    
    func hue(forInstitutionAtIndex index: Int) -> Float {
        return institutions[index].hue
    }
    
    func observeInstitutionList() {
        db.collection("institutions").order(by: "name").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de instituições: \(error!)")
            }
            
            self.institutions = snapshot.documents.flatMap { Institution(documentID: $0.documentID, data: $0.data()) }
            self.delegate?.viewModelDidChange?()
        }
    }
    
}
