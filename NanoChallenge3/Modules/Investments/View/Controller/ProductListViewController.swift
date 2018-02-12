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
    
    var subjectCellIndexPath: IndexPath?
    
    func setup(documentID: String?, name: String, hue: Float, balance: Double) {
        institution.documentID = documentID
        institution.name = name
        institution.hue = hue
        institution.balance = balance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
        vm.observeProductList()
        
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
        guard subjectCellIndexPath != nil else { return }
        
        // reúne os dados célula em questão
        let documentID = vm.documentID(forProductAtIndex: subjectCellIndexPath!.row)
        let name = vm.name(forProductAtIndex: subjectCellIndexPath!.row)
        let note = vm.note(forProductAtIndex: subjectCellIndexPath!.row)
        
        // prepara para edição do produto
        if let controller = segue.destination as? ProductViewController {
            controller.setup(documentID: documentID, name: name, note: note)
        }
        
        subjectCellIndexPath = nil
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
        return vm.numberOfProducts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        
        let name = vm.name(forProductAtIndex: indexPath.row)
        let note = vm.note(forProductAtIndex: indexPath.row)
        cell.setup(name: name, note: note)
        
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
            self.subjectCellIndexPath = indexPath
            self.performSegue(withIdentifier: "editProduct", sender: self)
        }
        
        action.image = UIImage(named: "icon-settings")
        action.backgroundColor = UIColor(white: 0.33, alpha: 0.5)
        return action
    }
}

