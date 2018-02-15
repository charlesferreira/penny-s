//
//  AllocateIncomeViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 14/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class IncomeAllocationViewController: BaseViewController {

    @IBOutlet weak var successIcon: UIImageView!
    @IBOutlet weak var leftoverLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var investmentVM = InvestmentViewModel()
    private lazy var productVM = ProductViewModel()
    private lazy var institutionVM = InstitutionViewModel()
    private lazy var vm = IncomeAllocationViewModel()
    
    var income: Int!
    var leftover: Int {
        return income - vm.balance
    }
    
    // prepara para criar um investimento
    func setup(investmentVM: InvestmentViewModel, productVM: ProductViewModel, institutionVM: InstitutionViewModel) {
        self.investmentVM = investmentVM
        self.productVM = productVM
        self.institutionVM = institutionVM
        investmentVM.delegate = self
        income = investmentVM.initialValue
    }
    
    // prepara para atualizar um investimento
    func setup(viewModel investmentVM: InvestmentViewModel, productVM: ProductViewModel, institutionVM: InstitutionViewModel, income: Int) {
        self.investmentVM = investmentVM
        self.productVM = productVM
        self.institutionVM = institutionVM
        investmentVM.delegate = self
        self.income = income
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
        
        updateLayout()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        disableUserInteraction()
        
        // atualiza o investimento
        investmentVM.balance += income
        investmentVM.persist()
        
        // atualiza o saldo do produto
        productVM.balance += income
        productVM.persist()
        
        // atualiza o saldo da instituição
        institutionVM.balance += income
        institutionVM.persist()
    }
    
    @IBAction func createCellTapped(_ sender: Any) {
        vm.createAllocation()
    }
    
    private func disableUserInteraction() {
        // feedback visual
        saveButton.isEnabled = false
        navigationItem.backBarButtonItem?.isEnabled = false
        view.endEditing(true)
        activityIndicator.startAnimating()
    }
    
    private func updateLayout() {
        leftoverLabel.text = leftover.asCurrency(symbol: "R$ ")
        saveButton.isEnabled = leftover == 0
        successIcon.alpha  = leftover == 0 ? 1 : 0.2
    }
}

extension IncomeAllocationViewController: ViewModelDelegate {
    
    func viewModelDidPersistData(_ viewModel: ViewModel) {
        if let investmentVM = viewModel as? InvestmentViewModel {
            vm.persist(investmentID: investmentVM.documentID!)
        }
    }
}

extension IncomeAllocationViewController: IncomeAllocationViewModelDelegate {
    
    func viewModelDidChange(_ viewModel: IncomeAllocationViewModel, tableViewNeedsDataReload: Bool) {
        updateLayout()
        if tableViewNeedsDataReload {
            tableView.reloadData()
        }
    }
    
    func viewModelDidPersistData(_ viewModel: IncomeAllocationViewModel) {
        dismiss(animated: true, completion: nil)
    }
}

extension IncomeAllocationViewController: IncomeAllocationTableViewCellDelegate {
    
    func tableViewCellDidChange(_ cell: IncomeAllocationTableViewCell) {
        vm.updateAllocation(withContentsOfCell: cell)
    }
    
    func tableViewCellDidUpdateValue(_ cell: IncomeAllocationTableViewCell) {
        vm.updateAllocation(withContentsOfCell: cell)
        updateLayout()
    }
}

extension IncomeAllocationViewController: IncomeAllocationTableViewCellDataSource {
    
    func tableViewCellNumberOfAccounts(_ cell: IncomeAllocationTableViewCell) -> Int {
        return vm.accountList.count
    }
    
    func tableViewCell(_ cell: IncomeAllocationTableViewCell, accountNameForRow row: Int) -> String {
        return vm.accountList[row]
    }
    
    func tableViewCell(_ cell: IncomeAllocationTableViewCell, tintForAccountAtIndex index: Int) -> Float {
        return vm.tint(forAccountAtIndex: index)
    }
    
    func delete(cellAtRow row: Int) {
        vm.delete(allocationForCellAtRow: row)
    }
}

extension IncomeAllocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeAllocationTableViewCell") as? IncomeAllocationTableViewCell else {
            fatalError("Erro ao obter célula para alocação de investimento")
        }
        
        cell.delegate = self
        cell.dataSource = self
        
        let allocation = vm.allocations[indexPath.row]
        cell.setup(accountIndex: allocation.index, value: allocation.value, cellRow: indexPath.row)
        
        return cell
    }
}


