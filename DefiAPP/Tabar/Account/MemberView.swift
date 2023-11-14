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
    @IBOutlet weak var logoutButton: CustomNextButton!
    
    let viewModel = MemberViewModel()
    
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
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        observeEvent()
    }
    
    func observeEvent() {
        viewModel.infoBindClosure = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.userLabel.text = self.viewModel.memeberInfo.nickname ?? ""
                self.emailLabel.text = self.viewModel.memeberInfo.email ?? ""
            }
        }
        viewModel.getMemberInfo()
    }
    
    @objc func logout() {
        SelectAlertView.shared.showInView(message: "是否確定要登出？", okAction: {
            GC.goLogout()
        })
    }
    
    
}
