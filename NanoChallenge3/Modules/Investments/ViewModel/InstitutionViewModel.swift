//
//  InstitutionViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase

final class InstitutionViewModel: ViewModel {
    
    private (set) var institution: Institution
    
    var name: String {
        get { return institution.name }
        set { institution.name = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    var hue: CGFloat {
        get { return CGFloat(institution.hue) }
        set { institution.hue = Float(newValue) }
    }
    
    convenience override init() {
        self.init(institution: Institution())
    }
    
    init(institution: Institution) {
        self.institution = institution
    }
    
    func persist() {
        db.collection("institutions").addDocument(data: institution.data) { (error) in
            guard error == nil else {
                print("Erro ao persistir instituição: \(error!)")
                return
            }
            
            self.delegate?.viewModelDidCreateDocument?()
        }
    }
    
    func validate() -> Bool {
        return !name.isEmpty
    }
    
}

