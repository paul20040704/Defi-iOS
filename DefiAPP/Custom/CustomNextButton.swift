//
//  CustomNextButton.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/10/30.
//

import UIKit

class CustomNextButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(hex: "#42B883")
        self.tintColor = UIColor(hex: "#FFFFFF")
        //self.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        //backgroundColor = UIColor(hex: "#42B883")
        self.titleLabel?.font = UIFont(name: "PingFangSC--Medium", size: 16)
        //self.isEnabled = false
    }

    func updateButton(isNext: Bool) {
        self.isEnabled = isNext
        self.tintColor = isNext ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#858A88")
        self.backgroundColor = isNext ? UIColor(hex: "#42B883") : UIColor(hex: "#E6EBE8")
    }
}
