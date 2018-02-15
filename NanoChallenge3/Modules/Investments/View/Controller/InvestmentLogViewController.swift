//
//  InvestmentLogViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 15/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InvestmentLogViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundTint: UIView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private lazy var productVM = ProductViewModel()
    private lazy var investmentVM = InvestmentViewModel()
    private lazy var vm = AccountEntryListViewModel()
    
    private var hue: CGFloat!
    
    func setup(productVM: ProductViewModel, investmentVM: InvestmentViewModel, hue: CGFloat) {
        self.productVM = productVM
        self.investmentVM = investmentVM
        self.hue = hue
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
        backgroundTint.backgroundColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        productLabel.text = productVM.name
        summaryLabel.text = investmentVM.summaryForEntryList
        balanceLabel.text = investmentVM.balance.asCurrency(symbol: "R$ ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.observeCollection(forAccountID: investmentVM.documentID!, type: .investment)
        tableView.reloadData()
        updateLayout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // vai atualizar valor do investimento
//        if let navigationController = segue.destination as? UINavigationController,
//            let controller = navigationController.topViewController as? InvestmentUpdateViewController {
//            controller.setup(productID: productVM.documentID!)
//        }
    }
    
    // cria um unwind segue no storyboard (método intencionalmente vazio)
    @IBAction func backToInvestmentLog(unwind: UIStoryboardSegue) {}
}

extension InvestmentLogViewController: ViewModelDelegate {
    
    func viewModelDidChange(_ viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension InvestmentLogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountEntryTableViewCell") as! AccountEntryTableViewCell
        
        cell.setup(viewModel: vm[indexPath.row])
        
        return cell
    }
}


