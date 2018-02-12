//
//  ViewModelDelegate.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

@objc protocol ViewModelDelegate: AnyObject {
    
    @objc optional func viewModelDidChange()
    
    @objc optional func viewModelDidCreateDocument()
    
    @objc optional func viewModelDidNotPersistData()
}

