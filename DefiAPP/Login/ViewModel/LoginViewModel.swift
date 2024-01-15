//
//  LoginViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import Foundation

class LoginViewModel {
    
    var loginResult: MessageClosure?
    var registerResult: MessageClosure?
    
    //var updateKeepAccount: StringClosure?
    var updateKeepButton: BoolClosure?
    
    func login(loginInfo: [String: Any]) {
        NS.fetchData(urlStr: "v1/User/login", method: "POST", parameters: loginInfo, isToken: false) {(result: Result<LoginData, APIError>)  in
            
            switch result {
            case .success(let fetchData):
                if let token = fetchData.data {
                    UserDefaultsManager.shared.token = token
                    if let exp = GC.decodeToken(token: token) {
                        UserDefaultsManager.shared.expTime = exp
                    }
                    
                    if let email = loginInfo["email"] as? String {
                        self.loginJudgeKeepEmail(email: email)
                    }
                    
                    self.loginResult?(true, "success")
                }
            case .failure(let error):
                switch error {
                case .networkError(let error):
                    self.loginResult?(false, error.localizedDescription)
                case .invalidStatusCode(_, let string):
                    self.loginResult?(false, string)
                case .apiError(let message):
                    if (message == "2FA verification code is required") {
                        self.loginResult?(true, "goTwofa")
                    }else {
                        self.loginResult?(false, message)
                    }
                }
            }
        }
    }
    
    //登入後判斷是否記住email
    func loginJudgeKeepEmail(email: String) {
        if (UserDefaultsManager.shared.isKeepAccount) {
            UserDefaultsManager.shared.keepAccount = email
        }else {
            UserDefaultsManager.shared.resetKeepAccount()
        }
    }
    
    //點擊記住帳號
    func keepButtonClick() {
        UserDefaultsManager.shared.isKeepAccount.toggle()
        self.updateKeepButton?(UserDefaultsManager.shared.isKeepAccount)
    }
    
    //註冊
    func register(loginInfo: [String: Any]) {
        NS.fetchData(urlStr: "v1/User", method: "POST", parameters: loginInfo, isToken: false) {(result: Result<RegisterModel, APIError>)  in
            
            switch result {
            case .success(_):
                self.registerResult?(true, "success")
            case .failure(let error):
                self.registerResult?(false, GC.resolveError(error: error))
            }
        }
    }
    
}
