//
//  LanuchVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/8.
//

import UIKit
import LocalAuthentication

class LanuchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        judgeToken()
    }
    
    func judgeToken() {
        let expTime = UD.integer(forKey: UserDefaultsKey.expTime.rawValue)
        let nowTime = GC.getTimeInterval()
        if expTime > nowTime {
            if let _ = UD.string(forKey: UserDefaultsKey.token.rawValue) {
                judgeFaceId()
            }else {
                GC.goLogin()
            }
        }else {
            GC.goLogin()
        }
    }
    
    //判斷是否開啟FaceID
    func judgeFaceId() {
        if (UD.bool(forKey: UserDefaultsKey.faceID.rawValue)) {
            let context = LAContext()
            var error: NSError?
            
            //檢查設備是否支持生物辨識
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "使用 Face ID 解鎖應用程式"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            GC.goMain()
                        }else {
                            GC.goLogout()
                            if let error = authenticationError as? LAError {
                                switch error.code {
                                case .appCancel:
                                    print("應用程式取消驗證")
                                case .userCancel:
                                    print("用戶取消驗證")
                                case .authenticationFailed:
                                    print("驗證失敗")
                                case .biometryNotAvailable:
                                    print("生物識別不可用")
                                case .biometryNotEnrolled:
                                    print("用戶未註冊生物識別")
                                case .biometryLockout:
                                    print("生物識別鎖定")
                                default:
                                    print("其他錯誤")
                                }
                            }
                        }
                    }
                }
            }else {
                //不支持生物辨識
                print(error?.localizedDescription ?? "生物辨識不可用")
            }
        }else {
            //直接進主畫面
            GC.goMain()
        }
    }

}
