//
//  LoginViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import Foundation

class LoginViewModel {
    
    var loginResult: ((_ result: Bool,_ message: String) ->())?
    var registerResult: ((_ result: Bool,_ message: String) ->())?
    
    var keepAccount: String = "" {
        didSet {
            updateKeepAccount?(keepAccount)
        }
    }
    
    var isKeepAccount = false {
        didSet {
            updateKeepButton?(isKeepAccount)
        }
    }
    
    var updateKeepAccount: ((String) -> ())?
    var updateKeepButton: ((Bool) -> ())?
    
    func login(loginInfo: [String: Any]) {
        NS.fetchData(urlStr: "v1/User/login", method: "POST", parameters: loginInfo, isToken: false) {(result: Result<LoginData, APIError>)  in
            
            switch result {
            case .success(let fetchData):
                if let token = fetchData.data {
                    UD.setValue(token, forKey: "token")
                    if let exp = GC.decodeToken(token: token) {
                        UD.setValue(exp, forKey: "expTime")
                    }
                    
                    if let email = loginInfo["email"] as? String {
                        self.loginJudgeKeepEmail(email: email)
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
    
    //登入後判斷是否記住email
    func loginJudgeKeepEmail(email: String) {
        UD.setValue(isKeepAccount, forKey: "isKeepAccount")
        if isKeepAccount {
            UD.setValue(email, forKey: "keepAccount")
        }else {
            UD.removeObject(forKey: "keepAccount")
        }
    }
    
    //判斷是否記住帳號
    func judgeKeep() {
        isKeepAccount = UD.bool(forKey: "isKeepAccount")
        if (isKeepAccount) {
            if let account = UD.string(forKey: "keepAccount") {
                keepAccount = account
            }
        }
    }
    
    //註冊
    func register(loginInfo: [String: Any]) {
        NS.fetchData(urlStr: "v1/User", method: "POST", parameters: loginInfo, isToken: false) {(result: Result<String, APIError>)  in
            
            switch result {
            case .success(_):
                self.registerResult?(true, "success")
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
                self.registerResult?(false, errorMessage)
            }
        }
    }
    
}
