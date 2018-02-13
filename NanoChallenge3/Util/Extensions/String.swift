//
//  String.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation
extension String {
    var numbersToDouble: Double {
        var numbers: String
        do {
            let regex = try NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
            let range = NSMakeRange(0, self.count)
            numbers = "0" + regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        } catch {
            numbers = "0"
        }
        
        return Double(numbers)! / 100
    }
}
