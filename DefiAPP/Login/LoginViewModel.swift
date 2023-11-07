//
//  LoginViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import Foundation

class LoginViewModel {
    
    var loginResult: ((_ result: Bool,_ message: String) ->())?
    
    func login(loginInfo: [String: Any]) {
        NS.fetchData(urlStr: "v1/User/login", method: "POST", parameters: loginInfo, isToken: false) {(result: Result<LoginData, APIError>)  in
            
            switch result {
            case .success(let fetchData):
                if let token = fetchData.data {
                    UD.setValue(token, forKey: "token")
                    if let exp = GC.decodeToken(token: token) {
                        UD.setValue(exp, forKey: "expTime")
                    }
                    self.loginResult?(true, "success")
                }
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
                self.loginResult?(false, errorMessage)
            }
        }
    }
    
    //取得已記住帳號
    
    
}
