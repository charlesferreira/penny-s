//
//  InvestmentViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InvestmentViewController: BaseViewController {

    @IBOutlet weak var purchaseDate: UIDatePicker!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var interestField: UITextField!
    @IBOutlet weak var liquidityField: UITextField!
    @IBOutlet weak var initialValueField: UITextField!
    @IBOutlet weak var initialValueContainer: UIView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    private lazy var vm = InvestmentViewModel()
    
    // prepara para criar um investimento
    func setup(productID: String) {
        vm.productID = productID
    }
    
    // prepara para editar um investimento
    func setup(viewModel vm: InvestmentViewModel) {
        self.vm = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view model
        vm.delegate = self
        
        // text fields
        interestField.delegate = self
        liquidityField.delegate = self
        initialValueField.delegate = self
        
        interestField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        liquidityField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        initialValueField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
        // date pickers
        purchaseDate.addTarget(self, action: #selector(datePickersChanged), for: .valueChanged)
        dueDate.addTarget(self, action: #selector(datePickersChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // correções de layout
        fixTextFieldsPlaceholderColor()
        updateNavigationBar()
        updateDatePickers()
        updateTextFields()
        updateSaveButton()
    }
    
    @objc func textFieldsChanged() {
        vm.interest = interestField.text ?? ""
        vm.liquidity = liquidityField.text ?? ""
        
        if initialValueField.isEnabled {
            vm.initialValue = (initialValueField.text ?? "").numbersToDouble
        }
        
        updateSaveButton()
    }
    
    @objc func datePickersChanged(sender: UIDatePicker) {
        vm.purchaseDate = purchaseDate.date
        vm.dueDate = dueDate.date
        updateSaveButton()
    }
    
    private func updateNavigationBar() {
        let isNew = (vm.documentID ?? "").isEmpty
        navigationItem.title = (isNew ? "Novo" : "Editar") + " Investimento"
        saveButton.title = isNew ? "Seguinte" : "OK"
    }
    
    private func updateDatePickers() {
        purchaseDate.date = vm.purchaseDate
        dueDate.date = vm.dueDate
    }
    
    private func updateTextFields() {
        interestField.text = vm.interest
        liquidityField.text = vm.liquidity
        initialValueField.text = vm.initialValue.asCurrency(symbol: "R$ ", zero: "", limit: 9_999_999_999.99)
        
        if vm.documentID != nil {
            initialValueField.isEnabled = false
            initialValueContainer.isHidden = true
            liquidityField.returnKeyType = .done
        }
    }
    
    private func updateSaveButton() {
        saveButton.isEnabled = vm.validate()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        // editando, apenas persiste
        if vm.documentID != nil {
            disableUserInteraction()
            vm.persist()
            return
        }
        
        // criando, precisa destinar valor inicial para reservas
        performSegue(withIdentifier: "allocateInvestment", sender: nil)
    }
    
    private func disableUserInteraction() {
        // feedback visual
        saveButton.isEnabled = false
        view.endEditing(true)
        activityIndicator.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AllocateIncomeViewController {
            controller.setup(viewModel: vm)
            return
        }
    }
    
    private func fixTextFieldsPlaceholderColor() {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.25)]
        interestField.attributedPlaceholder = NSAttributedString(string: interestField.placeholder ?? "", attributes: attributes)
        liquidityField.attributedPlaceholder = NSAttributedString(string: liquidityField.placeholder ?? "", attributes: attributes)
        initialValueField.attributedPlaceholder = NSAttributedString(string: initialValueField.placeholder ?? "", attributes: attributes)
    }
}

extension InvestmentViewController: ViewModelDelegate {
    
    func viewModelDidCreateDocument() {
        dismiss(animated: true, completion: nil)
    }
}

extension InvestmentViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == initialValueField,
            var text = initialValueField.text else { return true }
        
        if string == "" && !text.isEmpty {
            let secondToLast = text.index(before: text.endIndex)
            text = String(text[..<secondToLast])
        } else {
            text = (textField.text ?? "") + string
        }
        
        textField.text = text.numbersToDouble.asCurrency(symbol: "R$ ", zero: "", limit: 9_999_999_999.99)
        textFieldsChanged()
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField, initialValueField.isEnabled) {
        case (interestField, _):
            liquidityField.becomeFirstResponder()
        case (liquidityField, true):
            initialValueField.becomeFirstResponder()
        case (liquidityField, false):
            fallthrough
        default:
            view.endEditing(true)
        }
        
        return true
    }
    
}
