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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
        vm.observeCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let subjectCellIndexPath = sender as? IndexPath else { return }
        
        let savingAccountVM = vm[subjectCellIndexPath.row]
        
        if let controller = segue.destination as? SavingAccountViewController {
            controller.setup(viewModel: savingAccountVM)
        }
            
//            // prepara para lista de produtos
//        else if let controller = segue.destination as? ProductListViewController {
//            controller.setup(documentID: documentID, name: name, hue: hue, balance: balance)
//        }
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
        return vm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavingAccountTableViewCell") as! SavingAccountTableViewCell
        
        cell.setup(viewModel: vm[indexPath.row])
        
        return cell
    }
    
    // lista os produtos da instituição selecionada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listProducts", sender: indexPath)
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
            self.performSegue(withIdentifier: "editSavingAccount", sender: indexPath)
        }
        
        let hue = vm[indexPath.row].hue
        action.backgroundColor = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 0.5, alpha: 1)
        return action
    }
}


