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
    
    func setup(documentID: String?, name: String, hue: Float, goal: Double) {
        vm.documentID = documentID
        vm.name = name
        vm.hue = hue
        vm.goal = goal
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        // TODO: converter valor do campo de texto para Double
//        vm.goal = Double(goalField.text ?? "")
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
        goalField.text = vm.goal > 0 ? vm.goal.asCurrency() : ""
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

