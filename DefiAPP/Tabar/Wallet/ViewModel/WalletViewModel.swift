//
//  HistoryViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/21.
//

import Foundation
class WalletViewModel {
    var walletVC: WalletVC?
    
    //資產資訊
    var balanceDatas: [WalletData] = [] {
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
    
    //Swap資訊
    var swapInfoDic: [String: SwapData] = [:]
    //選擇的Swap
    var fromSymbol: String = "USDT" {
        didSet {
            self.selectSwapClosure?()
        }
    }
    
    //是否隱藏餘額
    lazy var isHideBalance: Bool = {
        return UD.bool(forKey: UserDefaultsKey.hideBalance.rawValue)
    }()
    
    var withdrawData: WithdrawData = WithdrawData()
    //帳本資訊
    var ledgerItems: [LedgerData] = [] {
        didSet {
            self.ledgerClosure?()
        }
    }
    
    var swapQuotationData: SwapQuotationData = SwapQuotationData() {
        didSet {
            self.swapQuotaionClosure?(true, "success")
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
    //選擇From Swap回調
    var selectSwapClosure: VoidClosure?
    //取得Swap詳細資訊回調
    var swapQuotaionClosure: MessageClosure?
    //Swap成功回調
    var swapClosure: MessageClosure?
    
    
    //取得餘額
    func getBalance() {
        NS.fetchData(urlStr: "v1/Ledger/balance", method: "GET", isToken: true) { (result: Result<BalanceModel, APIError>) in
            switch result {
            case .success(let fetchData):
                if !(fetchData.data.isEmpty) {
                    self.balanceDatas = fetchData.data
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
                self.withdrawClosure?(false, GC.resolveError(error: error))
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
    
    //點擊隱藏資產按鈕
    func changeHideBalance() {
        self.isHideBalance = !UD.bool(forKey: UserDefaultsKey.hideBalance.rawValue)
        UD.setValue(self.isHideBalance, forKey: UserDefaultsKey.hideBalance.rawValue)
        self.updateBalance?()
    }
    
    //取得SwapInfo
    func getSwapInfo() {
        NS.fetchData(urlStr: "v1/Ledger/SwapInfo", method: "GET", isToken: true) { (result: Result<SwapModel, APIError>) in
            switch result {
            case .success(let fetchData):
                for swapData in fetchData.data {
                    self.swapInfoDic[swapData.fromCryptocurrencySymbol ?? ""] = swapData
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //取得Swap詳細資訊
    func getSwapQuotaion(paramaters: [String: Any]) {
        NS.fetchData(urlStr: "v1/Ledger/swapquotation", method: "GET", parameters: paramaters, isToken: true) { (result: Result<SwapQuotationModel, APIError>) in
            switch result {
            case .success(let fetchData):
                self.swapQuotationData = fetchData.data
            case .failure(let error):
                self.swapQuotaionClosure?(false, GC.resolveError(error: error))
            }
        }
    }
    
    //Swap
    func postSwap(paramaters: [String: Any]) {
        NS.fetchData(urlStr: "v1/Ledger/swap", method: "POST", parameters: paramaters, isToken: true) { (result: Result<RenewModel, APIError>) in
            switch result {
            case .success(_):
                self.swapClosure?(true, "")
            case .failure(let error):
                self.swapClosure?(false, GC.resolveError(error: error))
            }
        }
    }
    
}
