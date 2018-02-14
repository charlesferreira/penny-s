//
//  ProductListViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class ProductListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceBackgroundTint: UIView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private lazy var institution = InstitutionViewModel()
    private lazy var vm = ProductListViewModel()
    
    func setup(viewModel institutionVM: InstitutionViewModel) {
        institution = institutionVM
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
        vm.observeCollection(forInstitutionID: institution.documentID!)
        
        updateLayout()
    }
    
    private func updateLayout() {
        navigationItem.title = institution.name
        balanceBackgroundTint.backgroundColor = UIColor(hue: CGFloat(institution.hue), saturation: 1, brightness: 1, alpha: 1)
        balanceLabel.text = institution.balance.asCurrency(symbol: "R$ ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            prepareSegue(to: segue.destination, forCellAtIndexPath: indexPath)
            return
        }
        
        // novo produto para instituição
        if let controller = segue.destination as? ProductViewController {
            controller.setup(institutionID: institution.documentID!)
        }
    }
    
    private func prepareSegue(to destination: UIViewController, forCellAtIndexPath indexPath : IndexPath) {
        // editar produto
        if let controller = destination as? ProductViewController {
            controller.setup(viewModel: vm[indexPath.row])
            return
        }
        
        // listar investimentos no produto
        if let controller = destination as? InvestmentListViewController {
            let hue = institution.hue
            controller.setup(productVM: vm[indexPath.row], hue: hue)
        }
    }
    
    // cria um unwind segue no storyboard (método intencionalmente vazio)
    @IBAction func backToProductList(unwind: UIStoryboardSegue) {}
}

extension ProductListViewController: ViewModelDelegate {
    
    func viewModelDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        
        cell.setup(viewModel: vm[indexPath.row])
        
        return cell
    }
    
    // lista os investimentos no produto selecionado
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listInvestments", sender: indexPath)
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
            self.performSegue(withIdentifier: "editProduct", sender: indexPath)
        }
        
//        action.image = UIImage(named: "icon-settings")
        action.backgroundColor = UIColor(white: 0.33, alpha: 0.5)
        return action
    }
}

