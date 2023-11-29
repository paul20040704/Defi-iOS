//
//  AccountVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/7.
//

import UIKit
import PKHUD

class AccountVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet var selectionButtons: [UIButton]!
    
    
    @IBOutlet weak var memberView: MemberView!
    @IBOutlet weak var settingView: SettingView!
    @IBOutlet weak var referralScrollView: UIScrollView!
    
    let memberViewModel = MemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        observeEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.memberViewModel.getMemberInfo()
    }
    
    func setUI() {
        selectionButtons.forEach { button in
            button.changeLayer(isSelect: button.tag == 0)
            button.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        }
        copyButton.addTarget(self, action: #selector(copyBtnClick), for: .touchUpInside)
    }
    
    func observeEvent() {
        HUD.show(.systemActivity, onView: self.view)
        
        memberViewModel.infoBindClosure = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                self.nameLabel.text = self.memberViewModel.memeberInfo.nickname ?? ""
                self.idLabel.text = "會員ID \(self.memberViewModel.memeberInfo.id ?? "")"
                self.memberView.userLabel.text = self.memberViewModel.memeberInfo.nickname ?? ""
                self.memberView.emailLabel.text = self.memberViewModel.memeberInfo.email ?? ""
            }
        }
        memberViewModel.getMemberInfo()
        
        memberView.changeUserClosure = { [weak self] in
            guard let self else { return }
            let changeNameVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "ChangeNameVC") as! ChangeNameVC
            changeNameVC.userName = self.memberViewModel.memeberInfo.nickname ?? ""
            self.navigationController?.show(changeNameVC, sender: nil)
        }
        
        settingView.goSatetyClosure = {
            let safetyVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "SafetyVC")
            self.navigationController?.show(safetyVC, sender: nil)
        }
    }

    
    //MARK: - Action
    @objc func copyBtnClick() {
        UIPasteboard.general.string = self.memberViewModel.memeberInfo.id ?? ""
        HUD.flash(.label("複製成功"), delay: 1.0)
    }
    
    @objc func selectClick(_ btn: UIButton) {
        selectionButtons.forEach { button in
            button.changeLayer(isSelect: button.tag == btn.tag)
        }
        
        memberView.isHidden = true
        settingView.isHidden = true
        referralScrollView.isHidden = true
        if btn.tag == 0 {
            memberView.isHidden = false
        }else if btn.tag == 1 {
            settingView.isHidden = false
        }else {
            referralScrollView.isHidden = false
        }
    }
    
    
}
