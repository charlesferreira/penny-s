//
//  ProductViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class ProductViewController: BaseViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    private lazy var vm = ProductViewModel()
    
    // prepara para criar produto
    func setup(institutionID: String) {
        vm.institutionID = institutionID
    }
    
    // prepara para editar produto
    func setup(viewModel vm: ProductViewModel) {
        self.vm = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        noteField.delegate = self
        vm.delegate = self
        
        fixTextFieldsPlaceholderColor()
        updateNavigationBar()
        updateTextFields()
        updateSaveButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
        nameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        noteField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
        updateNavigationBar()
        updateTextFields()
        updateSaveButton()
    }
    
    @objc func textFieldsChanged() {
        vm.name = nameField.text ?? ""
        vm.note = noteField.text ?? ""
        updateSaveButton()
    }
    
    private func updateNavigationBar() {
        navBarItem.title = (vm.name.isEmpty ? "Novo" : "Editar") + " Produto"
        saveButton.title = vm.name.isEmpty ? "Criar" : "OK"
    }
    
    private func updateTextFields() {
        nameField.text = vm.name
        noteField.text = vm.note
    }
    
    private func updateSaveButton() {
        saveButton.isEnabled = vm.validate()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if vm.isDirty {
            disableUserInteraction()
        }
        vm.persist()
    }
    
    private func disableUserInteraction() {
        // feedback visual
        saveButton.isEnabled = false
        view.endEditing(true)
        activityIndicator.startAnimating()
    }
    
    private func fixTextFieldsPlaceholderColor() {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.25)]
        nameField.attributedPlaceholder = NSAttributedString(string: nameField.placeholder ?? "", attributes: attributes)
        noteField.attributedPlaceholder = NSAttributedString(string: noteField.placeholder ?? "", attributes: attributes)
    }
}

extension ProductViewController: ViewModelDelegate {
    
    func viewModelDidPersistData(_ viewModel: ViewModel) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProductViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            noteField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return true
    }
    
}
