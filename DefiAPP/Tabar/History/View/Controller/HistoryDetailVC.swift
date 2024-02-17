//
//  HistoryDetailVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/17.
//

import UIKit
import PKHUD

class HistoryDetailVC: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var aprLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel: HistoryDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        observeEvent()
    }
    

    func setUI() {
        self.navigationItem.title = "詳細資訊"
        self.idLabel.text = viewModel?.itemsData.id ?? ""
        self.aprLabel.text = "\(viewModel?.itemsData.product.apr ?? 0)%"
        self.assetLabel.text = viewModel?.itemsData.product.asset ?? ""
        self.startLabel.text = viewModel?.itemsData.beginDate?.timeStrConvert()
        self.endLabel.text = viewModel?.itemsData.endDate?.timeStrConvert()
        self.amountLabel.text = "\(viewModel?.itemsData.amount ?? 0) USDT"
        self.autoSwitch.isOn = viewModel?.itemsData.autoRenewEnabled ?? false
        
        self.switchButton.addTarget(self, action: #selector(autoClick), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        
        if viewModel?.itemsData.statuses[0].status != "Effective" {
            bottomView.isHidden = true
        }
    }

    func observeEvent() {
        viewModel?.updateDamage = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.damageLabel.text = "\(self.viewModel?.damageDouble ?? 0) USDT"
            }
        }
        
        viewModel?.updateSwitch = { [weak self] isAuto in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                self.autoSwitch.isOn = isAuto
            }
        }
        
        viewModel?.errorClosure = { message in
            DispatchQueue.main.async {
                CustomAlertView.shared.showMe(message: message)
            }
        }
        
        viewModel?.revokeClosure = { [weak self] isRevoke, message in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                if isRevoke {
                    if let vcArr = self.navigationController?.viewControllers {
                        self.navigationController?.popToViewController(vcArr[0], animated: true)
                    }
                }else {
                    CustomAlertView.shared.showMe(message: message)
                }
            }
        }
        
        viewModel?.liquidatedDamage()
        
    }
    
    //MARK: - action
    @objc func autoClick() {
        if let memberInfo = UserDefaultsManager.shared.memberInfo {
            if memberInfo.isGaEnabled {
                TwofaAlertView.shared.showInView { code in
                    let paramaters: [String: Any] = ["userId": memberInfo.id ?? "", "verificationCode": code, "contractId": self.viewModel?.itemsData.id ?? "", "enabled": !(self.autoSwitch.isOn)]
                    self.viewModel?.autoRenew(parameters: paramaters)
                    HUD.show(.systemActivity, onView: self.view)
                }
            }else {
                CustomAlertView.shared.showMe(message: "未開啟兩步驟驗證。")
            }
        }
    }
    
    @objc func nextClick() {
        if let memberInfo = UserDefaultsManager.shared.memberInfo {
            if memberInfo.isGaEnabled {
                SelectAlertView.shared.showInView(title: "是否確定解約？", message: "請參考解約手續費說明提前解約您將支付手續費  \(self.viewModel?.damageDouble ?? 0) USDT。") {
                    TwofaAlertView.shared.showInView { code in
                        let paramaters: [String: Any] = ["userId": memberInfo.id ?? "", "verificationCode": code, "contractId": self.viewModel?.itemsData.id ?? ""]
                        self.viewModel?.revokeContract(parameters: paramaters)
                        HUD.show(.systemActivity, onView: self.view)
                    }
                }
            }else {
                CustomAlertView.shared.showMe(message: "未開啟兩步驟驗證。")
            }
        }
    }
    
    
}
