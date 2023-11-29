//
//  HistoryViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/21.
//

import Foundation

class WalletViewModel {
    var balance: Int = 0 {
        didSet {
            self.updateBalance?()
        }
    }
    //幣種出金資訊
    var assetTypeInfo: AssetTypeData = AssetTypeData(withdrawFee: 0, minimumWithdraw: 0, maximumWithdraw: 0, explorerUrl: "") {
        didSet {
            self.assetTypeClosure?()
        }
    }
    //出金成功回傳
    var withdrawData: WithdrawData = WithdrawData()
    //帳本資訊
    var ledgerItems: [LedgerData] = [] {
        didSet {
            self.ledgerClosure?()
        }
    }
    
    var updateBalance: VoidClosure?
    //取得出金資訊回調
    var assetTypeClosure: VoidClosure?
    //出金成功回調
    var withdrawClosure: MessageClosure?
    //內部轉帳回調
    var transferClosure: MessageClosure?
    //用途取得帳本回調
    var ledgerClosure: VoidClosure?
    
    //取得餘額
    func getBalance() {
        NS.fetchData(urlStr: "v1/Ledger/balance", method: "GET", isToken: true) { (result: Result<BalanceModel, APIError>) in
            switch result {
            case .success(let fetchData):
                if !(fetchData.data.isEmpty) {
                    let filterData = fetchData.data.filter { $0.account == "Checking"}
                    self.balance = filterData.first?.balance ?? 0
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //取得幣種出金資訊
    func getAssetType() {
        NS.fetchData(urlStr: "v1/Sys/config/chain/Ethereum/USDT", method: "GET", isToken: true) { (result: Result<AssetType, APIError>) in
            switch result {
            case .success(let fetchData):
                self.assetTypeInfo = fetchData.data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //新增出金申請
    func withdraw(paramaters: [String: Any]) {
        NS.fetchData(urlStr: "v1/Withdraw", method: "POST",parameters: paramaters, isToken: true) { (result: Result<WithdrawModel, APIError>) in
            switch result {
            case .success(let fetchData):
                self.withdrawData = fetchData.data
                self.withdrawClosure?(true, "")
            case .failure(let error):
                var errorMessage = "fail"
                switch error {
                case .networkError(let error):
                    errorMessage = error.localizedDescription
                case .invalidStatusCode(_, let string):
                    errorMessage = string
                case .apiError(let message):
                    errorMessage = message
                }
                self.withdrawClosure?(false, errorMessage)
            }
        }
    }
    
    //內部轉帳
    func transferUser(paramaters: [String: Any]) {
        NS.fetchData(urlStr: "v1/Ledger/transfer/user", method: "POST", isToken: true) { (result: Result<WithdrawModel, APIError>) in
            
        }
    }
    
    //以用途取的帳本紀錄
    func getLedger(from purpose: String) {
        NS.fetchData(urlStr: "v1/Ledger/\(purpose)/100/1", method: "GET", isToken: true) { (result: Result<LedgerModel, APIError>) in
            switch result {
            case .success(let fetchData):
                self.ledgerItems = fetchData.data.items
            case .failure(let error):
                self.ledgerItems = []
                print(error.localizedDescription)
            }
        }
    }
    
}
