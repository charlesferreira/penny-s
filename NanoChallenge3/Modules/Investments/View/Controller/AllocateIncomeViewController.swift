//
//  AllocateIncomeViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 14/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class IncomeAllocationViewController: BaseViewController {

    @IBOutlet weak var leftoverLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var investmentVM = InvestmentViewModel()
//    private lazy var vm = IncomeAllocationViewModel()
    
    // prepara para criar um investimento
    func setup(viewModel investmentVM: InvestmentViewModel) {
        self.investmentVM = investmentVM
    }
    
    // prepara para editar um investimento
//    func setup(viewModel vm: InvestmentViewModel) {
//        self.vm = vm
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view model
//        vm.delegate = self
        
        // atualiza o layout
        leftoverLabel.text = investmentVM.initialValue.asCurrency(symbol: "R$ ")
    }
    
    private func updateSaveButton() {
//        saveButton.isEnabled = vm.validate()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        // editando, apenas persiste
//        if vm.documentID != nil {
//            disableUserInteraction()
//            vm.persist()
//            return
//        }
        
        // criando, precisa destinar valor inicial para reservas
        performSegue(withIdentifier: "allocateInvestment", sender: nil)
    }
    
    private func disableUserInteraction() {
        // feedback visual
        saveButton.isEnabled = false
        view.endEditing(true)
        activityIndicator.startAnimating()
    }
}

extension IncomeAllocationViewController: ViewModelDelegate {
    
    func viewModelDidCreateDocument() {
        dismiss(animated: true, completion: nil)
    }
}


