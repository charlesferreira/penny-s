//
//  SavingAccountLogViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 15/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class SavingAccountLogViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundTint: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private lazy var accountVM = SavingAccountViewModel()
    private lazy var vm = AccountEntryListViewModel()
    
    func setup(accountVM: SavingAccountViewModel) {
        self.accountVM = accountVM
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
    }
    
    private func updateLayout() {
        backgroundTint.backgroundColor = UIColor(hue: CGFloat(accountVM.hue), saturation: 1, brightness: 1, alpha: 1)
        nameLabel.text = accountVM.name
        summaryLabel.text = accountVM.summary
        balanceLabel.text = accountVM.balance.asCurrency(symbol: "R$ ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.observeCollection(forAccountID: accountVM.documentID!, type: .savingAccount)
        tableView.reloadData()
        updateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // vai transferir dinheiro entre reservas
//        if let navigationController = segue.destination as? UINavigationController,
//            let controller = navigationController.topViewController as? SavingAccountUpdateViewController {
//            controller.setup(productID: productVM.documentID!)
//        }
    }
    
    // cria um unwind segue no storyboard (método intencionalmente vazio)
    @IBAction func backToSavingAccountLog(unwind: UIStoryboardSegue) {}
}

extension SavingAccountLogViewController: ViewModelDelegate {
    
    func viewModelDidChange(_ viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SavingAccountLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountEntryTableViewCell") as! AccountEntryTableViewCell
        
        cell.setup(viewModel: vm[indexPath.row])
        
        return cell
    }
}


