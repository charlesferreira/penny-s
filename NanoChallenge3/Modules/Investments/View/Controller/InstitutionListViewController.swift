//
//  InstitutionListViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InstitutionListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private lazy var vm = InstitutionListViewModel()
    
    var subjectCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // table view
        tableView.delegate = self
        tableView.dataSource = self
    
        // view model
        vm.delegate = self
        vm.observeInstitutionList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard subjectCellIndexPath != nil else { return }
        
        // reúne os dados célula em questão
        let documentID = vm.documentID(forInstitutionAtIndex: subjectCellIndexPath!.row)
        let name = vm.name(forInstitutionAtIndex: subjectCellIndexPath!.row)
        let hue = vm.hue(forInstitutionAtIndex: subjectCellIndexPath!.row)
        let balance = vm.balance(forInstitutionAtIndex: subjectCellIndexPath!.row)
        
        // prepara para edição da instituição
        if let controller = segue.destination as? InstitutionViewController {
            controller.setup(documentID: documentID, name: name, hue: hue)
        }
            
        // prepara para lista de produtos
        else if let controller = segue.destination as? ProductListViewController {
            controller.setup(documentID: documentID, name: name, hue: hue, balance: balance)
        }
        
        subjectCellIndexPath = nil
    }
    
    // cria um unwind segue no storyboard (método intencionalmente vazio)
    @IBAction func backToInstitutionList(unwind: UIStoryboardSegue) {}
}

extension InstitutionListViewController: ViewModelDelegate {
    
    func viewModelDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension InstitutionListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            self.performSegue(withIdentifier: "editInstitution", sender: self)
        }
        
        let hue = vm.hue(forInstitutionAtIndex: indexPath.row)
        action.image = UIImage(named: "icon-settings")
        action.backgroundColor = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 0.5, alpha: 1)
        return action
    }
}

