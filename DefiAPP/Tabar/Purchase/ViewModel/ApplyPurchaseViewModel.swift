//
//  ApplyPurchaseViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/15.
//

import Foundation

class ApplyPurchaseViewModel {
    var balance: Double = 0 {
        didSet {
            self.availableBalance = self.countAvailableBalance()
        }
    }
    
    let amount: Double
    let productId: String
    
    var availableBalance: Double = 0{
        didSet {
            self.updateClosure?()
        }
    }
    
    var isTerms: Bool = false {
        didSet {
            self.termsClosure?(isTerms)
        }
    }
    
    var isAgree: Bool = false {
        didSet{
            self.agreeClosure?(isAgree)
        }
    }
    
    var updateClosure: VoidClosure?
    var termsClosure: BoolClosure?
    var agreeClosure: BoolClosure?
    var purchaseClosure: MessageClosure?
    
    init(amount: Double, productId: String) {
        self.amount = amount
        self.productId = productId
    }
    
    private func countAvailableBalance() -> Double{
        return balance - amount
    }
    
    //取得餘額
    func getBalance() {
        NS.fetchData(urlStr: "v1/Ledger/balance", method: "GET", isToken: true) { (result: Result<BalanceModel, APIError>) in
            switch result {
            case .success(let fetchData):
                if !(fetchData.data.isEmpty) {
                    let filterData = fetchData.data.filter { $0.symbol == "USDT"}
                    self.balance = filterData.first?.balance ?? 0
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //新增合約
    func addContract(paramates: [String: Any]) {
        NS.fetchData(urlStr: "v1/contract", method: "POST", parameters: paramates, isToken: true) { (result: Result<ContractModel, APIError>) in
            switch result {
            case .success(let fetchData):
                self.purchaseClosure?(true, fetchData.data.endDate?.timeStrConvert() ?? "")
            case .failure(let error):
                self.purchaseClosure?(false, GC.resolveError(error: error))
            }
        }
    }
    
}
