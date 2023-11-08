//
//  MemberView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/7.
//

import UIKit

class MemberView: UIView {
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
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MemberView", bundle: bundle)
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(xibView)
        
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func commonInit() {
        logoutButton.updateButton(isNext: true)
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
        GC.goLogout()
    }
}
