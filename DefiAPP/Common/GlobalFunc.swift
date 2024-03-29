//
//  GlobalFunc.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import Foundation
import UIKit

class GlobalFunc {
    
    static let shared = GlobalFunc()
    
    private init() {}
    
    func goMain() {
        let tabBar = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarNavigation")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = tabBar
            }
        }
    }
    
    func goLogin() {
        let loginNavigaionC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = loginNavigaionC
            }
        }
    }
    
    func goLogout() {
        UserDefaultsManager.shared.logoutReset()
        let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = loginVC
            }
        }
    }
    
    //取得當前timeInterval
    func getTimeInterval() -> Int {
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    //解析token Base64取得過期時間
    func decodeToken(token: String) -> Int? {
        let component = token.components(separatedBy: ".")
        let base64Str = component[1]
        if let data = Data(base64Encoded: base64Str) {
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let exp = jsonDic["exp"]
                    return exp as? Int
                }else {
                    print("無法解析Json")
                    return nil
                }
            }catch{
                print("error: \(error.localizedDescription)")
                return nil
            }
        }else {
            return nil
        }
    }
    
    //解析錯誤訊息
    func resolveError(error: APIError) -> String {
        var errorMessage = "fail"
        switch error {
        case .networkError(let error):
            errorMessage = error.localizedDescription
        case .invalidStatusCode(_, let string):
            errorMessage = string
        case .apiError(let message):
            errorMessage = message
        }
        return errorMessage
    }
}

