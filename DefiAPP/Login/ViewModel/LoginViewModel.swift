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
    
    var updateKeepAccount: StringClosure?
    var updateKeepButton: BoolClosure?
    
    func login(loginInfo: [String: Any]) {
        NS.fetchData(urlStr: "v1/User/login", method: "POST", parameters: loginInfo, isToken: false) {(result: Result<LoginData, APIError>)  in
            
            switch result {
            case .success(let fetchData):
                if let token = fetchData.data {
                    UD.setValue(token, forKey: UserDefaultsKey.token.rawValue)
                    if let exp = GC.decodeToken(token: token) {
                        UD.setValue(exp, forKey: UserDefaultsKey.expTime.rawValue)
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
        UD.setValue(isKeepAccount, forKey: UserDefaultsKey.isKeepAccount.rawValue)
        if isKeepAccount {
            UD.setValue(email, forKey: UserDefaultsKey.keepAccount.rawValue)
        }else {
            UD.removeObject(forKey: UserDefaultsKey.keepAccount.rawValue)
        }
    }
    
    //判斷是否記住帳號
    func judgeKeep() {
        isKeepAccount = UD.bool(forKey: UserDefaultsKey.isKeepAccount.rawValue)
        if (isKeepAccount) {
            if let account = UD.string(forKey: UserDefaultsKey.keepAccount.rawValue) {
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
