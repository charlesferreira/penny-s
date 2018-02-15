//
//  IncomeAllocationTableViewCell.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 14/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import UIKit

class IncomeAllocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountPicker: UIPickerView!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var backgroundTint: UIView!
    
    weak var delegate: IncomeAllocationTableViewCellDelegate?
    weak var dataSource: IncomeAllocationTableViewCellDataSource?
    
    var row: Int!
    var accountPickerSelectedRow: Int!
    
    var allocationInfo: (index: Int, value: Double) {
        return (index: accountPickerSelectedRow, value: (valueField.text ?? "").numbersToDouble)
    }
    
    func setup(accountIndex index: Int, value: Double, cellRow row: Int) {
        self.row = row
        
        // account
        accountPicker.delegate = self
        accountPicker.dataSource = self
        accountPicker.selectRow(index, inComponent: 0, animated: false)
        accountPickerSelectedRow = index
        
        // value
        valueField.delegate = self
        valueField.text = value.asCurrency(symbol: "R$ ")
        
        // background
        updateBackground(hue: dataSource?.tableViewCell(self, tintForAccountAtIndex: index))
    }
    
    func updateBackground(hue: Float?) {
        guard let hue = hue else { return }
        
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.5) {
                self.backgroundTint.backgroundColor = UIColor(hue: CGFloat(hue), saturation: 1, brightness: 1, alpha: 1)
                self.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        dataSource?.delete(cellAtRow: row)
    }
}

extension IncomeAllocationTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        delegate?.tableViewCellDidChange(self)
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
        
        return false
    }
}

extension IncomeAllocationTableViewCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        accountPickerSelectedRow = row
        if let hue = dataSource?.tableViewCell(self, tintForAccountAtIndex: row) {
            updateBackground(hue: hue)
        }
        delegate?.tableViewCellDidChange(self)
    }
}

extension IncomeAllocationTableViewCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.tableViewCellNumberOfAccounts(self) ?? 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource?.tableViewCell(self, accountNameForRow: row)
    }
}
