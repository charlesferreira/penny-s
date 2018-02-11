//
//  Institution.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct Institution {
    
    let name: String
    let colorHue: Float
    
    // todo: lazy load... talvez uma Factory com lista de produtos e outa sem??? :D
    lazy var products: [Product]
    
}
