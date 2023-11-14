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
    
    var infoBindClosure: (() ->())?
    
    
    func getMemberInfo() {
        NS.fetchData(urlStr: "v1/User", method: "GET", isToken: true) { (result: Result<MemberModel, APIError>)  in
            switch result {
            case .success(let fetchData):
                self.memeberInfo = fetchData.data
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
