//
//  InstitutionListViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InstitutionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var vm = InstitutionListViewModel()
    
    var editingRowIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // table view
        tableView.delegate = self
        tableView.dataSource = self
    
        // view model
        vm.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicator.startAnimating()
        vm.loadInstitutionList()
    }
    
    func viewModelDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfInstitutions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstitutionTableViewCell") as! InstitutionTableViewCell
        
        let name = vm.name(forInstitutionAtIndex: indexPath.row)
        let hue = vm.hue(forInstitutionAtIndex: indexPath.row)
        cell.setup(name: name, hue: CGFloat(hue))
        
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
            self.performSegue(withIdentifier: "editInstitution", sender: self)
        }
        
        let hue = vm.hue(forInstitutionAtIndex: indexPath.row)
        action.image = UIImage(named: "icon-settings")
        action.backgroundColor = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 0.5, alpha: 1)
        return action
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? InstitutionViewController,
            editingRowIndexPath != nil else { return }
        
        controller.vm.name = vm.name(forInstitutionAtIndex: editingRowIndexPath!.row)
        controller.vm.hue = CGFloat(vm.hue(forInstitutionAtIndex: editingRowIndexPath!.row))
        
        editingRowIndexPath = nil
    }
    
    // método vazio, apenas para criar um unwind segue no storyboard
    @IBAction func backToInstitutionList(unwind: UIStoryboardSegue) {}

}

