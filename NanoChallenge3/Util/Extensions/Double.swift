//
//  Double.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

extension Double {
    
    func asCurrency(symbol: String? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol ?? ""
        
        if let formattedValue = formatter.string(from: self as NSNumber) {
            return formattedValue
        }
        
        return self.description
    }
    
}
