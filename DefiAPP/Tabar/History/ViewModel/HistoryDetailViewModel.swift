//
//  HistoryDetailViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/17.
//

import Foundation

class HistoryDetailViewModel {
    
    let itemsData: ItemsData
    
    init(itemsData: ItemsData) {
        self.itemsData = itemsData
    }
    
    var damageDouble: Double = 0
    
    var updateDamage: VoidClosure?
    var updateSwitch: BoolClosure?
    var errorClosure: StringClosure?
    var revokeClosure: MessageClosure?
    
    //以合約ID估算違約金
    func liquidatedDamage() {
        NS.fetchData(urlStr: "v1/Contract/\(itemsData.id ?? "")/liquidateddamage", method: "GET", isToken: true) { (result: Result<DamageModel, APIError>) in
            switch result {
            case .success(let fetchData):
                self.damageDouble = fetchData.data ?? 0
                self.updateDamage?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //啟用/停用自動續約
    func autoRenew(parameters: [String: Any]) {
        NS.fetchData(urlStr: "v1/Contract/autorenew", method: "PUT", parameters: parameters, isToken: true) { (result: Result<RenewModel, APIError>) in
            switch result {
            case .success(let fetchData):
                self.updateSwitch?(fetchData.data)
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
                self.errorClosure?(errorMessage)
            }
        }
    }
    //提前解約
    func revokeContract(parameters: [String: Any]) {
        NS.fetchData(urlStr: "v1/Contract/revoke", method: "PUT", parameters: parameters, isToken: true) { (result: Result<RevokeModel, APIError> ) in
            switch result {
            case .success(_):
                self.revokeClosure?(true, "success")
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
                self.revokeClosure?(false, errorMessage)
            }
        }
    }
    
    
}
