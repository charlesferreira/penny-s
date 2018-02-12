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
    
    lazy var vm = ProductListViewModel()
    
    var editingRowIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // view model
        vm.delegate = self
        vm.observeProductList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? ProductViewController,
            editingRowIndexPath != nil else { return }
        
        controller.vm.documentID = vm.documentID(forProductAtIndex: editingRowIndexPath!.row)
        controller.vm.name = vm.name(forProductAtIndex: editingRowIndexPath!.row)
        controller.vm.note = vm.note(forProductAtIndex: editingRowIndexPath!.row)
        
        editingRowIndexPath = nil
    }
    
    // método vazio, apenas para criar um unwind segue no storyboard
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
            self.editingRowIndexPath = indexPath
            self.performSegue(withIdentifier: "editProduct", sender: self)
        }
        
        action.image = UIImage(named: "icon-settings")
        action.backgroundColor = UIColor(white: 0.33, alpha: 0.5)
        return action
    }
}

