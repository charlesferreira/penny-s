//
//  InstitutionViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InstitutionViewController: BaseViewController {

    @IBOutlet weak var backgroundTint: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var huePickerView: HueColorPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    private lazy var vm = InstitutionViewModel()
    
    func setup(viewModel vm: InstitutionViewModel) {
        self.vm = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.delegate = self
        huePickerView.delegate = self
        vm.delegate = self
        
        fixNamePlaceholderColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
        nameField.addTarget(self, action: #selector(nameFieldChanged), for: .editingChanged)
        
        updateNavigationBar()
        updateBackgroundColor()
        updateNameField()
        updateSaveButton()
    }
    
    @objc func nameFieldChanged() {
        vm.name = nameField.text ?? ""
        updateSaveButton()
    }
    
    private func updateNavigationBar() {
        navBarItem.title = (vm.name.isEmpty ? "Nova" : "Editar") + " Instituição"
        saveButton.title = vm.name.isEmpty ? "Criar" : "OK"
    }
    
    private func updateBackgroundColor() {
        backgroundTint.backgroundColor = UIColor(hue: CGFloat(vm.hue), saturation: 1, brightness: 1, alpha: 1)
    }
    
    private func updateNameField() {
        nameField.text = vm.name
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
    
    private func fixNamePlaceholderColor() {
        nameField.attributedPlaceholder = NSAttributedString(string: nameField.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.25)])
    }
}

extension InstitutionViewController: ViewModelDelegate {
    
    func viewModelDidPersistData(_ viewModel: ViewModel) {
        dismiss(animated: true, completion: nil)
    }
}

extension InstitutionViewController: HueColorPickerDelegate {
    
    func hueColorPickerChanged(sender: HueColorPickerView, hue: CGFloat, point: CGPoint, state: UIGestureRecognizerState) {
        vm.hue = Float(hue)
        updateBackgroundColor()
    }
}

extension InstitutionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
