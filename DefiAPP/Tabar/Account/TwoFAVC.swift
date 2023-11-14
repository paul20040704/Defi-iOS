//
//  TwoFAVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/10.
//

import UIKit

class TwoFAVC: UIViewController {

    @IBOutlet weak var twoSwitch: UISwitch!
    @IBOutlet weak var switchButton: UIButton!
    
    var viewModel = TwoFAViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "兩步驟驗證"
        self.navigationItem.backButtonTitle = ""
        // Do any additional setup after loading the view.
        setUI()
        observeEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getGaEnable()
    }

    func setUI() {
        switchButton.addTarget(self, action: #selector(switchClick), for: .touchUpInside)
    }
    
    func observeEvent() {
        viewModel.updateSwitch = { [weak self] enable in
            guard let self else { return }
            self.twoSwitch.isOn = enable
        }
        //viewModel.getGaEnable()
    }
    
    @objc func switchClick() {
        SelectAlertView.shared.showInView(message: "請問是否開啟或關閉兩步驟驗證?", okAction: {
            if (self.twoSwitch.isOn) {
                let twoPauseVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "TwoPauseVC")
                self.navigationController?.show(twoPauseVC, sender: nil)
            }else {
                let twoEnableVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "TwoEnableVC")
                self.navigationController?.show(twoEnableVC, sender: nil)
            }
        })
    }
    
    
}
