//
//  SafetyVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/10.
//

import UIKit

class SafetyVC: UIViewController {

    @IBOutlet weak var twoFAButton: UIButton!
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBOutlet weak var changePwButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var viewModel = SafetyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "安全性與登入"
        self.navigationItem.backButtonTitle = ""
        setUI()
        observeEvent()
    }
    
    func setUI() {
        twoFAButton.addTarget(self, action: #selector(goTwoFA), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchClick), for: .touchUpInside)
    }
    
    func observeEvent() {
        viewModel.updateSwitch = { [weak self] isOpen in
            guard let self else { return }
            self.switchButton.isOn = isOpen
        }
        viewModel.getFaceID()
    }
    
    @objc func goTwoFA() {
        let twoFAVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "TwoFAVC")
        self.navigationController?.show(twoFAVC, sender: nil)
    }
    
    @objc func switchClick() {
        viewModel.switchFaceId()
    }
}