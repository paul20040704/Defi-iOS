//
//  UIButttonEx.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/10/30.
//

import Foundation
import UIKit

extension UIButton {
    
    //點擊隱藏&顯示密碼方法
    func togglePasswordVisibility(textField: UITextField) {
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        let imageName = textField.isSecureTextEntry ? "hide" : "show"
        self.setImage(UIImage(named: imageName), for: .normal)
    }
    
    //點擊按鈕改變外觀
    func changeLayer(isSelect: Bool) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = isSelect ? UIColor(hex: "#42B883")?.cgColor : UIColor(hex: "E0E0E0")?.cgColor
        borderLayer.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2)
        self.layer.addSublayer(borderLayer)
        
        self.setTitleColor(isSelect ? UIColor(hex: "#42B883") : UIColor(hex: "#858A88"), for: .normal)
        
    }
    
}
