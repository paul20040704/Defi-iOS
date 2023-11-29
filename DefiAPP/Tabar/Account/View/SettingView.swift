//
//  SettingView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/7.
//

import UIKit

class SettingView: UIView, NibOwnerLoadable {

    @IBOutlet weak var safetyButton: UIButton!
    
    var goSatetyClosure: VoidClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        loadNibContent()
        commonInit()
    }

    func commonInit() {
        safetyButton.addTarget(self, action: #selector(goSatety), for: .touchUpInside)
    }
    
    @objc func goSatety() {
        self.goSatetyClosure?()
    }
    
}
