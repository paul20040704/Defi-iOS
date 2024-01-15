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
    
    var updateSwitch: BoolClosure?
    
    var updateGaKey: VoidClosure?
    
    var putGaResult: MessageClosure?
    
    func getGaEnable() {
        if let memberInfo = UserDefaultsManager.shared.memberInfo {
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
                UserDefaultsManager.shared.memberInfo = fetchData.data
                self.putGaResult?(true, "")
            case .failure(let error):
                self.putGaResult?(false, GC.resolveError(error: error))
            }
        }
    }
    
    //修改完後更新MemberInfo
//    func getMemberInfo() {
//        NS.fetchData(urlStr: "v1/User", method: "GET", isToken: true) { (result: Result<MemberModel, APIError>)  in
//            switch result {
//            case .success(let fetchData):
//                GC.updateMemberInfo(fetchData: fetchData.data)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    
}
