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
    
    //判斷是否開啟FaceId
    func getFaceID() {
        let isFaceIdOpen = UD.bool(forKey: UserDefaultsKey.faceID.rawValue)
        self.updateSwitch?(isFaceIdOpen)
    }
    
    //開關FaceId
    func switchFaceId() {
        let isFaceIdOpen = UD.bool(forKey: UserDefaultsKey.faceID.rawValue)
        UD.setValue(!isFaceIdOpen, forKey: UserDefaultsKey.faceID.rawValue)
    }
    
    //變更使用者密碼
    func changPassword(paramates: [String: Any]) {
        NS.fetchData(urlStr: "v1/User/password", method: "PUT", parameters: paramates, isToken: true) { (result: Result<MemberModel, APIError>) in
            switch result {
            case .success(let fetchData):
                //成功並更新MemberInfo
                GC.updateMemberInfo(fetchData: fetchData.data)
                self.changePwClosure?(true, "Success")
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
                self.changePwClosure?(false, errorMessage)
            }
        }
    }
    
    
}
