//
//  Date.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 13/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        
        return formatter.string(from: self)
    }
    
}
