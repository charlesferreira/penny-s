//
//  InvestmentListViewModel.swift
//  NanoChallenge3
//
//  Created by Charles Ferreira on 13/02/2018.
//  Copyright © 2018 Charles Ferreira. All rights reserved.
//

import Foundation

final class InvestmentListViewModel: ViewModel {
    
    private var investments: [Investment] = []
    
    var numberOfInvestments: Int {
        return investments.count
    }
    
    func viewModel(forInvestmentAtIndex index: Int) -> InvestmentViewModel {
        return InvestmentViewModel(investment: investments[index])
    }
    
    func documentID(forInvestmentAtIndex index: Int) -> String? {
        return investments[index].documentID
    }
    
    func productID(forInvestmentAtIndex index: Int) -> String {
        return investments[index].productID
    }
    
    func purchaseDate(forInvestmentAtIndex index: Int) -> String {
        return investments[index].purchaseDate.toString()
    }
    
    func summary(forInvestmentAtIndex index: Int) -> String {
        let investment = investments[index]
        let summary: [String] = [investment.interest, investment.liquidity, investment.dueDate.toString()]
        return summary.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func balance(forInvestmentAtIndex index: Int) -> Double {
        return investments[index].balance
    }
    
    func observeInvestmentList(forProductID productID: String) {
        db.collection("investments").whereField("productID", isEqualTo: productID).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot, error == nil else {
                fatalError("Erro ao obter lista de investimentos: \(error!)")
            }
            
            self.investments = snapshot.documents.flatMap { Investment(documentID: $0.documentID, data: $0.data()) }
            self.delegate?.viewModelDidChange?()
        }
    }
    
}


