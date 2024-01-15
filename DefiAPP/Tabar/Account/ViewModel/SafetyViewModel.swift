//
//  SafetyViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/10.
//

import Foundation

class SafetyViewModel {
    
    var updateSwitch: BoolClosure?
    var changePwClosure: MessageClosure?
    
    //開關FaceId
    func switchFaceId() {
        UserDefaultsManager.shared.isOpenFaceId.toggle()
    }
    
    //變更使用者密碼
    func changPassword(paramates: [String: Any]) {
        NS.fetchData(urlStr: "v1/User/password", method: "PUT", parameters: paramates, isToken: true) { (result: Result<MemberModel, APIError>) in
            switch result {
            case .success(let fetchData):
                //成功並更新MemberInfo
                UserDefaultsManager.shared.memberInfo = fetchData.data
                self.changePwClosure?(true, "Success")
            case .failure(let error):
                self.changePwClosure?(false, GC.resolveError(error: error))
            }
        }
    }
    
    
}
