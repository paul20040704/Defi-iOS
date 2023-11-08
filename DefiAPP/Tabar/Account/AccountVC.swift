//
//  AccountVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/7.
//

import UIKit

class AccountVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attestLabel: UILabel!
    
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var referralButton: UIButton!
    
    @IBOutlet weak var memberView: MemberView!
    @IBOutlet weak var settingView: SettingView!
    @IBOutlet weak var referralScrollView: UIScrollView!
    
    let memberViewModel = MemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUI()
    }
    
    func setUI() {
        memberButton.changeLayer(isSelect: true)
        
        memberButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        setButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        referralButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        
        memberView.commonInit()
        observeEvent()
    }
    
    func observeEvent() {
        memberViewModel.infoBindClosure = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.nameLabel.text = self.memberViewModel.memeberInfo.nickname ?? ""
            }
        }
    }

    
    
    //MARK: - Action
    @objc func selectClick(_ btn: UIButton) {
        if btn.tag == 0 {
            memberButton.changeLayer(isSelect: true)
            setButton.changeLayer(isSelect: false)
            referralButton.changeLayer(isSelect: false)
            memberView.isHidden = false
            settingView.isHidden = true
            referralScrollView.isHidden = true
        }else if btn.tag == 1 {
            memberButton.changeLayer(isSelect: false)
            setButton.changeLayer(isSelect: true)
            referralButton.changeLayer(isSelect: false)
            memberView.isHidden = true
            settingView.isHidden = false
            referralScrollView.isHidden = true
        }else {
            memberButton.changeLayer(isSelect: false)
            setButton.changeLayer(isSelect: false)
            referralButton.changeLayer(isSelect: true)
            memberView.isHidden = true
            settingView.isHidden = true
            referralScrollView.isHidden = false
        }
    }
    
    
}
