//
//  TwoFAViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/10.
//

import Foundation

class TwoFAViewModel {
    
    var gaData = GaData() {
        didSet {
            self.updateGaKey?()
        }
    }
    
    var updateSwitch: ((Bool) ->())?
    
    var updateGaKey: (() ->())?
    
    var putGaResult: ((_ result: Bool,_ message: String) ->())?
    
    func getGaEnable() {
        if let memberInfo = GC.getMemberInfo() {
            self.updateSwitch?(memberInfo.isGaEnabled)
        }
    }
    
    
    //取得兩步驟驗證金鑰
    func getGaKey() {
        NS.fetchData(urlStr: "v1/User/ga", method: "GET", isToken: true) { (result: Result<GaModel, APIError>) in
            switch result {
            case .success(let fetchData):
                self.gaData = fetchData.data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //啟用或停用GA
    func putGaEnable(paramates: [String: Any]) {
        NS.fetchData(urlStr: "v1/User/ga", method: "PUT",parameters: paramates, isToken: true) {(result: Result<MemberModel, APIError>) in
            switch result {
            case .success(let fetchData):
                //成功並更新MemberInfo
                if let data = try? PropertyListEncoder().encode(fetchData.data) {
                    UD.setValue(data, forKey: UserDefaultsKey.memberInfo.rawValue)
                    print("memberInfo 更新")
                }
                self.putGaResult?(true, "")
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
                self.putGaResult?(false, errorMessage)
            }
        }
    }
    
    //修改完後更新MemberInfo
    func getMemberInfo() {
        NS.fetchData(urlStr: "v1/User", method: "GET", isToken: true) { (result: Result<MemberModel, APIError>)  in
            switch result {
            case .success(let fetchData):
                if let data = try? PropertyListEncoder().encode(fetchData.data) {
                    UD.setValue(data, forKey: UserDefaultsKey.memberInfo.rawValue)
                    print("memberInfo 更新")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
