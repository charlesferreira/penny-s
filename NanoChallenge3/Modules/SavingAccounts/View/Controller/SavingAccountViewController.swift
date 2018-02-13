//
//  SavingAccountViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 12/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class SavingAccountViewController: BaseViewController {
    
    @IBOutlet weak var backgroundTint: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var goalField: UITextField!
    @IBOutlet weak var huePickerView: HueColorPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var vm = SavingAccountViewModel()
    
    func setup(documentID: String?, name: String, hue: Float, goal: Double, balance: Double) {
        vm.documentID = documentID
        vm.name = name
        vm.hue = hue
        vm.goal = goal
        vm.balance = balance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        goalField.delegate = self
        huePickerView.delegate = self
        vm.delegate = self
        
        fixTextFieldsPlaceholderColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
        nameField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        
        updateNavigationBar()
        updateBackgroundColor()
        updateTextFields()
        updateSaveButton()
    }
    
    @objc func textFieldsChanged() {
        vm.name = nameField.text ?? ""
        vm.goal = goalField.text?.numbersToDouble ?? 0
        updateSaveButton()
    }
    
    private func updateNavigationBar() {
        navigationItem.title = (vm.name.isEmpty ? "Nova" : "Editar") + " Reserva"
        saveButton.title = vm.name.isEmpty ? "Criar" : "OK"
    }
    
    private func updateBackgroundColor() {
        backgroundTint.backgroundColor = UIColor(hue: CGFloat(vm.hue), saturation: 1, brightness: 1, alpha: 1)
    }
    
    private func updateTextFields() {
        nameField.text = vm.name
        goalField.text = vm.goal.asCurrency(symbol: "R$ ", zero: "")
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
        goalField.attributedPlaceholder = NSAttributedString(string: goalField.placeholder ?? "", attributes: attributes)
    }
}

extension SavingAccountViewController: ViewModelDelegate {
    
    func viewModelDidCreateDocument() {
        dismiss(animated: true, completion: nil)
    }
}

extension SavingAccountViewController: HueColorPickerDelegate {
    
    func hueColorPickerChanged(sender: HueColorPickerView, hue: CGFloat, point: CGPoint, state: UIGestureRecognizerState) {
        vm.hue = Float(hue)
        updateBackgroundColor()
    }
}

extension SavingAccountViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == goalField,
            var text = goalField.text else { return true }
        
        // lembrete: não mexer em strings com sono... zzzz
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
        if textField == nameField {
            goalField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
}

