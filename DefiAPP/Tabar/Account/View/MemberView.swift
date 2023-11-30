//
//  MemberView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/7.
//

import UIKit

class MemberView: UIView, NibOwnerLoadable {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var changeUserClosure: VoidClosure?
    
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
        userButton.addTarget(self, action: #selector(changeClick), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc func changeClick() {
        self.changeUserClosure?()
    }
    
    @objc func logout() {
        SelectAlertView.shared.showInView(message: "是否確定要登出？", okAction: {
            GC.goLogout()
        })
    }
    
    
}
