//
//  InstitutionViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 11/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InstitutionViewController: BaseViewController, HueColorPickerDelegate, ViewModelDelegate, UITextFieldDelegate {

    @IBOutlet weak var backgroundOverlay: UIView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var huePickerView: HueColorPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var vm = InstitutionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        huePickerView.delegate = self
        vm.delegate = self
        
        fixNamePlaceholderColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.becomeFirstResponder()
        nameLabel.addTarget(self, action: #selector(nameLabelChanged), for: .editingChanged)
        
        updateBackgroundColor()
        updateNameLabel()
        updateSaveButton()
    }
    
    @objc func nameLabelChanged() {
        vm.name = nameLabel.text ?? ""
        updateSaveButton()
    }
    
    func hueColorPickerChanged(sender: HueColorPickerView, hue: CGFloat, point: CGPoint, state: UIGestureRecognizerState) {
        vm.hue = hue
        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
        backgroundOverlay.backgroundColor = UIColor(hue: vm.hue, saturation: 1, brightness: 1, alpha: 1)
    }
    
    private func updateNameLabel() {
        nameLabel.text = vm.name
    }
    
    private func updateSaveButton() {
        saveButton.isEnabled = vm.validate()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        disableUserInteraction()
        vm.persist()
    }
    
    func viewModelDidCreateDocument() {
        dismiss(animated: true, completion: nil)
    }
    
    private func disableUserInteraction() {
        // feedback visual
        saveButton.isEnabled = false
        view.endEditing(true)
        activityIndicator.startAnimating()
    }
    
    private func fixNamePlaceholderColor() {
        nameLabel.attributedPlaceholder = NSAttributedString(string: nameLabel.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 1, alpha: 0.25)])
    }

}
