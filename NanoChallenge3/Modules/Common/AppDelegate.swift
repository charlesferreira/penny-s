//
//  AppDelegate.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 09/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // configura o banco de dados
        FirebaseApp.configure()
        
        // configura os estilos-padrão
        setupTableViewCellStyles()
        setupNavigationBarStyles()
        setupTabBarStyles()
        
        return true
    }
    
    fileprivate func setupTableViewCellStyles() {
        // configura o estilo das células de tabela selecionadas
        let colorView = UIView()
        colorView.backgroundColor = UIColor(white: 0.5, alpha: 0.9)
        UITableViewCell.appearance().selectedBackgroundView = colorView
    }
    
    fileprivate func setupNavigationBarStyles() {
        // configura a fontes das Navigation Bar
        let navBarAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-CondensedBold", size: 17)!]
        UINavigationBar.appearance().titleTextAttributes = navBarAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarAttributes, for: .selected)
        UIBarButtonItem.appearance().setTitleTextAttributes(navBarAttributes, for: .disabled)
    }
    
    fileprivate func setupTabBarStyles() {
        // configura a font das Tab Bar Item
        let tabBarAttributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-CondensedBold", size: 10)!]
        UITabBarItem.appearance().setTitleTextAttributes(tabBarAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(tabBarAttributes, for: .selected)
    }

}

