//
//  DocumentSerializable.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

protocol DocumentSerializable {
    
    init?(data: [String: Any])
    
    var data: [String: Any] { get }
    
}
