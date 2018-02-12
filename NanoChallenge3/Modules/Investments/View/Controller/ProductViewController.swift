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
    
    lazy var vm = ProductViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.delegate = self
        
        fixTextFieldsPlaceholderColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
        nameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
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
        navigationItem.title = (vm.name.isEmpty ? "Nova" : "Editar") + " instituição"
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
        disableUserInteraction()
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
    
    func viewModelDidCreateDocument() {
        dismiss(animated: true, completion: nil)
    }
}