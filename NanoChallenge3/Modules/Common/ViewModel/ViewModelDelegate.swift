//
//  ViewModelDelegate.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

@objc protocol ViewModelDelegate: AnyObject {
    
    @objc optional func viewModelDidChange(_ viewModel: ViewModel)
    
    @objc optional func viewModelDidPersistData(_ viewModel: ViewModel)
    
    @objc optional func viewModelDidNotPersistData(_ viewModel: ViewModel)
}

