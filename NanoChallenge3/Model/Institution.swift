//
//  Institution.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

struct Institution {
    
    var name: String = ""
    var hue: Float = 0.66

}

extension Institution: DocumentSerializable {
    
    init?(data: [String : Any]) {
        guard let name = data["name"] as? String,
            let hue = data["hue"] as? Float else { return nil }
        
        self.init(name: name, hue: hue)
    }
    
    var data: [String : Any] {
        return [
            "name": name,
            "hue": hue
        ]
    }
    
}
