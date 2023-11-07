//
//  StringEx.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import Foundation

extension String {
    //驗證是否為信箱
    func validateEmail() -> Bool {
        if self.isEmpty {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    //驗證密碼
    func validatePassword() -> Bool {
        if self.isEmpty {
            return false
        }
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d@$#!%*?&]{8,20}$"
        let passwordTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }
    
}
