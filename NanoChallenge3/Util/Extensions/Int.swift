//
//  Int.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

extension Int {
    
    func asCurrency(symbol: String? = nil, zero: String? = nil, limit: Int? = nil) -> String {
        if zero != nil && self == 0 {
            return zero!
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol ?? ""
        
        let value = Double(limit != nil && self > limit! ? limit! : self) / 100.0
        if let formattedValue = formatter.string(from: value as NSNumber) {
            return formattedValue
        }
        
        return self.description
    }
    
}
