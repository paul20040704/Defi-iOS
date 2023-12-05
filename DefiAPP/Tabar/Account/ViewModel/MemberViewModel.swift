//
//  MemberViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/8.
//

import Foundation

class MemberViewModel {
    
    var memeberInfo: MemberInfo = MemberInfo() {
        didSet {
            self.infoBindClosure?()
        }
    }
    
    var infoBindClosure: VoidClosure?
    var changeUserClosure: MessageClosure?
    
    func getMemberInfo() {
        NS.fetchData(urlStr: "v1/User", method: "GET", isToken: true) { (result: Result<MemberModel, APIError>)  in
            switch result {
            case .success(let fetchData):
                self.memeberInfo = fetchData.data
                GC.updateMemberInfo(fetchData: fetchData.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //更新MemberInfo
    func updateMemberInfo() {
        if let memberInfo = GC.getMemberInfo() {
            self.memeberInfo = memberInfo
        }
    }
    
    //變更使用者名稱
    func changUserName(paramates: [String: Any]) {
        NS.fetchData(urlStr: "v1/User/nickname", method: "PUT", parameters: paramates, isToken: true) { (result: Result<MemberModel, APIError>) in
            switch result {
            case .success(let fetchData):
                //成功並更新MemberInfo
                GC.updateMemberInfo(fetchData: fetchData.data)
                self.changeUserClosure?(true, "Success")
            case .failure(let error):
                self.changeUserClosure?(false, GC.resolveError(error: error))
            }
        }
    }

    
}
