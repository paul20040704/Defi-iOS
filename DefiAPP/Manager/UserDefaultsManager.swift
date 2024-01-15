//
//  UserDefaultsManager.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/12/7.
//

import Foundation

enum UserDefaultsKey: String {
    case token
    case expTime
    case isKeepAccount
    case keepAccount
    case memberInfo
    case faceID
    case hideBalance
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    //是否隱藏餘額
    var isHideBalance: Bool {
        get {
            return UD.bool(forKey: UserDefaultsKey.hideBalance.rawValue)
        }
        set {
            UD.set(newValue, forKey: UserDefaultsKey.hideBalance.rawValue)
        }
    }
    
    //是否開啟FaceId
    var isOpenFaceId: Bool {
        get {
            return UD.bool(forKey: UserDefaultsKey.faceID.rawValue)
        }
        set {
            UD.set(newValue, forKey: UserDefaultsKey.faceID.rawValue)
        }
    }
    
    //會員資訊
    var memberInfo: MemberInfo? {
        get {
            if let data = UD.data(forKey: UserDefaultsKey.memberInfo.rawValue), let member = try? PropertyListDecoder().decode(MemberInfo.self, from: data){
                return member
            }
            return nil
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UD.setValue(data, forKey: UserDefaultsKey.memberInfo.rawValue)
                print("memberInfo 更新")
            }
        }
    }
    
    //Token
    var token: String? {
        get {
            return UD.string(forKey: UserDefaultsKey.token.rawValue)
        }
        set {
            UD.set(newValue, forKey: UserDefaultsKey.token.rawValue)
        }
    }
    
    //過期時間
    var expTime: Int {
        get {
            return UD.integer(forKey: UserDefaultsKey.expTime.rawValue)
        }
        set {
            UD.set(newValue, forKey: UserDefaultsKey.expTime.rawValue)
        }
    }
    
    //是否記住登入帳號
    var isKeepAccount: Bool {
        get {
            return UD.bool(forKey: UserDefaultsKey.isKeepAccount.rawValue)
        }
        set {
            UD.set(newValue, forKey: UserDefaultsKey.isKeepAccount.rawValue)
        }
    }
    
    //記住的帳號
    var keepAccount: String {
        get {
            return UD.string(forKey: UserDefaultsKey.keepAccount.rawValue) ?? ""
        }
        set {
            UD.set(newValue, forKey: UserDefaultsKey.keepAccount.rawValue)
        }
    }
    
    //清除記住的帳號
    func resetKeepAccount() {
        UD.removeObject(forKey: UserDefaultsKey.keepAccount.rawValue)
    }
    
    //登出清除配置
    func logoutReset() {
        UD.removeObject(forKey: UserDefaultsKey.token.rawValue)
        UD.removeObject(forKey: UserDefaultsKey.expTime.rawValue)
        UD.removeObject(forKey: UserDefaultsKey.memberInfo.rawValue)
    }
    
    
    
    
}
