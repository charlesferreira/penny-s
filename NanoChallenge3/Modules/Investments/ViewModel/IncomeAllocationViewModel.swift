//
//  IncomeAllocationViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 14/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Firebase

class IncomeAllocationViewModel {
    
    weak var delegate: IncomeAllocationViewModelDelegate?
    
    private var accountsVM = SavingAccountListViewModel()
    private var investmentVM = InvestmentViewModel()
    
    private (set) var accountList: [String]!
    private (set) var allocations: [(index: Int, value: Int)] = []
    
    let db: Firestore
    
    var numberOfEntriesToPersist = 0
    
    var count: Int {
        return allocations.count
    }
    
    var balance: Int {
        return allocations.reduce(0) { $0 + $1.value }
    }
    
    init() {
        db = Firestore.firestore()
        accountsVM.delegate = self
        accountsVM.observeCollection()
    }
    
    func createAllocation() {
        let leftover = delegate?.leftover ?? 0
        allocations.append((index: 0, value: leftover))
        delegate?.viewModelDidChange(self, tableViewNeedsDataReload: true)
    }
    
    func updateAllocation(withContentsOfCell cell: IncomeAllocationTableViewCell) {
        allocations[cell.row] = cell.allocationInfo
        delegate?.viewModelDidChange(self, tableViewNeedsDataReload: false)
    }
    
    func accountName(forCellAtRow row: Int) -> String {
        return accountsVM[row].name
    }
    
    func tint(forAccountAtIndex index: Int) -> Float {
        return accountsVM[index].hue
    }
    
    func delete(allocationForCellAtRow row: Int) {
        allocations.remove(at: row)
        delegate?.viewModelDidChange(self, tableViewNeedsDataReload: true)
    }
    
    func persist(investmentID: String) {
        var accountEntries = makeSavingAccountEntries()
        accountEntries.append(makeInvestmentAccountEntry(investmentID: investmentID))
        numberOfEntriesToPersist = accountEntries.count
        for entry in accountEntries {
            entry.delegate = self
            entry.persist()
        }
        
        updateSavingAccounts()
    }
    
    func updateSavingAccounts() {
        for allocation in allocations {
            guard allocation.value != 0 else { continue }
            
            let account = accountsVM[allocation.index]
            account.balance += allocation.value
            account.persist()
        }
    }
    
    private func makeSavingAccountEntries() -> [AccountEntryViewModel] {
        var entries = [AccountEntryViewModel]()
        for allocation in allocations {
            guard allocation.value != 0 else { continue }
            
            entries.append(AccountEntryViewModel(entry: AccountEntry(
                documentID: nil,
                accountID: accountsVM[allocation.index].documentID!,
                accountType: .savingAccount,
                date: Date(),
                value: allocation.value,
                note: "")))
        }
        return entries
    }
    
    private func makeInvestmentAccountEntry(investmentID: String) -> AccountEntryViewModel {
        return AccountEntryViewModel(entry: AccountEntry(
            documentID: nil,
            accountID: investmentID,
            accountType: .investment,
            date: Date(),
            value: balance,
            note: ""))
    }
    
}

extension IncomeAllocationViewModel: ViewModelDelegate {
    
    func viewModelDidPersistData(_ viewModel: ViewModel) {
        numberOfEntriesToPersist -= 1
        if numberOfEntriesToPersist == 0 {
            delegate?.viewModelDidPersistData(self)
        }
    }
    
    func viewModelDidChange(_ viewModel: ViewModel) {
        if count == 0 {
            accountList = accountsVM.accounts.flatMap { $0.name }
            createAllocation()
        }
    }
    
}
