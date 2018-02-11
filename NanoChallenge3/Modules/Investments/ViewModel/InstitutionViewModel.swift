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
    
    override var documentID: String? {
        get { return institution.documentID }
        set { institution.documentID = newValue }
    }
    
    var name: String {
        get { return institution.name }
        set {
            institution.name = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            isDirty = true
        }
    }
    
    var hue: CGFloat {
        get { return CGFloat(institution.hue) }
        set {
            institution.hue = Float(newValue)
            isDirty = true
        }
    }
    
    convenience override init() {
        self.init(institution: Institution())
    }
    
    init(institution: Institution) {
        self.institution = institution
    }
    
    func persist() {
        super.persist(data: institution.data, toCollection: "institutions") { error in
            guard error == nil else {
                fatalError("Erro ao persistir instituição: \(error!)")
            }
            
            self.delegate?.viewModelDidCreateDocument?()
        }
    }
    
    func validate() -> Bool {
        return !name.isEmpty
    }
    
}

