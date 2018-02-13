//
//  Double.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

extension Double {
    
    func asCurrency(symbol: String? = nil, zero: String? = nil, limit: Double? = nil) -> String {
        if zero != nil && self == 0 {
            return zero!
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol ?? ""
        
        let value = limit != nil && self > limit! ? limit! : self
        if let formattedValue = formatter.string(from: value as NSNumber) {
            return formattedValue
        }
        
        return self.description
    }
    
}
