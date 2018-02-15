//
//  InvestmentListViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 13/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InvestmentListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceBackgroundTint: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private lazy var institutionVM = InstitutionViewModel()
    private lazy var productVM = ProductViewModel()
    private lazy var vm = InvestmentListViewModel()
    
    private var institutionName: String!
    private var hue: CGFloat!
    
    func setup(institutionVM: InstitutionViewModel, productVM: ProductViewModel, hue: Float) {
        self.institutionVM = institutionVM
        self.productVM = productVM
        self.hue = CGFloat(hue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
        vm.observeCollection(forProductID: productVM.documentID!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateLayout()
    }
    
    private func updateLayout() {
        productNameLabel.text = productVM.name
        navigationItem.backBarButtonItem?.title = institutionName
        balanceBackgroundTint.backgroundColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        balanceLabel.text = productVM.balance.asCurrency(symbol: "R$ ")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            prepareSegue(to: segue.destination, forCellAtIndexPath: indexPath)
            return
        }
        
        // novo investimento no produto
        if let navigationController = segue.destination as? UINavigationController,
            let controller = navigationController.topViewController as? InvestmentViewController {
            controller.setup(institutionVM: institutionVM, productVM: productVM)
        }
    }
    
    private func prepareSegue(to destination: UIViewController, forCellAtIndexPath indexPath : IndexPath) {
        // editar investimento
        if let navigationController = destination as? UINavigationController,
            let controller = navigationController.topViewController as? InvestmentViewController {
            controller.setup(institutionVM: institutionVM, productVM: productVM, investmentVM: vm[indexPath.row])
            return
        }
        
        // listar histórico do investimento
        if let controller = destination as? InvestmentLogViewController {
            controller.setup(institutionVM: institutionVM, productVM: productVM, investmentVM: vm[indexPath.row], hue: hue)
        }
    }
    
    // cria um unwind segue no storyboard (método intencionalmente vazio)
    @IBAction func backToInvestmentList(unwind: UIStoryboardSegue) {}
}

extension InvestmentListViewController: ViewModelDelegate {
    
    func viewModelDidChange(_ viewModel: ViewModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension InvestmentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentTableViewCell") as! InvestmentTableViewCell
        
        cell.setup(viewModel: vm[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showInvestmentLog", sender: indexPath)
    }
    
    // exibe as opções da célula ao swipe pra esquerda
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = contextualEditAction(forRowAtIndexPath: indexPath)
        let swipeConfig = UISwipeActionsConfiguration(actions: [editAction])
        return swipeConfig
    }
    
    // ação de edicão da célula
    func contextualEditAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Editar") { _, _, _ in
            self.performSegue(withIdentifier: "editInvestment", sender: indexPath)
        }
        
        action.backgroundColor = UIColor(white: 0.33, alpha: 0.5)
        return action
    }
}


