//
//  SavingAccountListViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class SavingAccountListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var vm = SavingAccountListViewModel()
    
    var subjectCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
        vm.observeSavingAccountList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard subjectCellIndexPath != nil else { return }
        
        // reúne os dados célula em questão
        let documentID = vm.documentID(forSavingAccountAtIndex: subjectCellIndexPath!.row)
        let name = vm.name(forSavingAccountAtIndex: subjectCellIndexPath!.row)
        let hue = vm.hue(forSavingAccountAtIndex: subjectCellIndexPath!.row)
        let goal = vm.goal(forSavingAccountAtIndex: subjectCellIndexPath!.row)
        let balance = vm.balance(forSavingAccountAtIndex: subjectCellIndexPath!.row)
        
        // prepara para edição da instituição
        if let controller = segue.destination as? SavingAccountViewController {
            controller.setup(documentID: documentID, name: name, hue: hue, goal: goal)
        }
            
            // prepara para lista de produtos
        else if let controller = segue.destination as? ProductListViewController {
            controller.setup(documentID: documentID, name: name, hue: hue, balance: balance)
        }
        
        subjectCellIndexPath = nil
    }
    
    // cria um unwind segue no storyboard (método intencionalmente vazio)
    @IBAction func backToSavingAccountList(unwind: UIStoryboardSegue) {}
}

extension SavingAccountListViewController: ViewModelDelegate {
    
    func viewModelDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SavingAccountListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfSavingAccounts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavingAccountTableViewCell") as! SavingAccountTableViewCell
        
        let name = vm.name(forSavingAccountAtIndex: indexPath.row)
        let hue = vm.hue(forSavingAccountAtIndex: indexPath.row)
        let goal = vm.goal(forSavingAccountAtIndex: indexPath.row)
        let balance = vm.balance(forSavingAccountAtIndex: indexPath.row)
        cell.setup(name: name, hue: CGFloat(hue), goal: goal, balance: balance)
        
        return cell
    }
    
    // lista os produtos da instituição selecionada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subjectCellIndexPath = indexPath
        performSegue(withIdentifier: "listProducts", sender: self)
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
            self.performSegue(withIdentifier: "editSavingAccount", sender: self)
        }
        
        let hue = vm.hue(forSavingAccountAtIndex: indexPath.row)
//        action.image = UIImage(named: "icon-settings")
        action.backgroundColor = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 0.5, alpha: 1)
        return action
    }
}


