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
    @IBOutlet weak var balanceLabel: UILabel!
    
    private lazy var product = ProductViewModel()
    private lazy var vm = InvestmentListViewModel()
    
    private var institutionName: String!
    private var hue: CGFloat!
    
    func setup(productID: String?, name: String, hue: Float, balance: Double) {
        product.documentID = productID
        product.name = name
        product.balance = balance
        self.hue = CGFloat(hue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
        vm.observeInvestmentList(forProductID: product.documentID!)
        
        updateLayout()
    }
    
    private func updateLayout() {
        navigationItem.title = product.name
        navigationItem.backBarButtonItem?.title = institutionName
        balanceBackgroundTint.backgroundColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        balanceLabel.text = product.balance.asCurrency(symbol: "R$ ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let institutionID = institution.documentID else { return }
        
        // prepara para exibir tela de edição do produto
//        if let controller = segue.destination as? InvestmentViewController {
//            if subjectCellIndexPath == nil {
//                // novo produto
//                controller.setup(institutionID: institutionID)
//            } else {
//                // produto existente
//                let documentID = vm.documentID(forInvestmentAtIndex: subjectCellIndexPath!.row)
//                let name = vm.name(forInvestmentAtIndex: subjectCellIndexPath!.row)
//                let note = vm.note(forInvestmentAtIndex: subjectCellIndexPath!.row)
//
//                controller.setup(documentID: documentID, institutionID: institutionID, name: name, note: note)
//            }
//            
//        }
    }
    
    // cria um unwind segue no storyboard (método intencionalmente vazio)
    @IBAction func backToInvestmentList(unwind: UIStoryboardSegue) {}
}

extension InvestmentListViewController: ViewModelDelegate {
    
    func viewModelDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension InvestmentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfInvestments
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentTableViewCell") as! InvestmentTableViewCell
        
        let purchaseDate = vm.purchaseDate(forInvestmentAtIndex: indexPath.row)
        let summary = vm.summary(forInvestmentAtIndex: indexPath.row)
        let balance = vm.balance(forInvestmentAtIndex: indexPath.row)
        cell.setup(purchaseDate: purchaseDate, summary: summary, balance: balance)
        
        return cell
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


