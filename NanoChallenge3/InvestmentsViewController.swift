//
//  ViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 09/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InvestmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var vm: InvestmentsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        vm = InvestmentsViewModel()
        vm.delegate = self
    }
    
    func modelDidUpdate() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.investments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentTableViewCell") as! InvestmentTableViewCell
        let investment = vm.investments[indexPath.row]
        cell.layout(for: investment)
        
        return cell
    }

}

