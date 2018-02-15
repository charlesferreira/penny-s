//
//  InvestmentNewEntryViewController.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 15/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class InvestmentNewEntryViewController: BaseViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var valueField: UITextField!
    
    private var investmentVM: InvestmentViewModel!
    private var productVM: ProductViewModel!
    private var institutionVM: InstitutionViewModel!
    
    func setup(investmentVM: InvestmentViewModel, productVM: ProductViewModel, institutionVM: InstitutionViewModel) {
        self.investmentVM = investmentVM
        self.productVM = productVM
        self.institutionVM = institutionVM
    }
    
    override func viewDidLoad() {
        valueField.delegate = self
        updateSaveButton()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        performSegue(withIdentifier: "allocateNewEntry", sender: self)
    }
    
    func updateSaveButton() {
        saveButton.isEnabled = (valueField.text?.numbersToDouble ?? 0) > 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? IncomeAllocationViewController else { return }
        
        let income = valueField.text!.numbersToDouble
        controller.setup(viewModel: investmentVM, productVM: productVM, institutionVM: institutionVM, income: income)
    }
}

extension InvestmentNewEntryViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = valueField.text else { return true }
        
        if string == "" && !text.isEmpty {
            let secondToLast = text.index(before: text.endIndex)
            text = String(text[..<secondToLast])
        } else {
            text = (textField.text ?? "") + string
        }
        
        textField.text = text.numbersToDouble.asCurrency(symbol: "R$ ", zero: "", limit: 9_999_999_999.99)
        updateSaveButton()
        return false
    }
    
}
