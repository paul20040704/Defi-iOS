//
//  ApplyPurchaseVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/15.
//

import UIKit
import PKHUD

class ApplyPurchaseVC: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel: ApplyPurchaseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        observeEvent()
    }
    
    func setUI() {
        self.navigationItem.title = "申購"
        
        termsButton.addTarget(self, action: #selector(agreeButtonClick), for: .touchUpInside)
        agreeButton.addTarget(self, action: #selector(agreeButtonClick), for: .touchUpInside)
        nextButton.updateButton(isNext: false)
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }
    
    func observeEvent() {
        viewModel?.updateClosure = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.balanceLabel.text = "\(self.viewModel?.balance ?? 0) USDT"
                self.amountLabel.text = "\(self.viewModel?.amount ?? 0) USDT"
                self.availableLabel.text = "\(self.viewModel?.availableBalance ?? 0) USDT"
                self.availableLabel.textColor = (self.viewModel?.availableBalance ?? 0) >= 0 ? UIColor(hex: "AAAEAC"): UIColor.red
            }
        }
        
        viewModel?.getBalance()
        
        viewModel?.termsClosure = { [weak self] isAgree in
            guard let self else { return }
            let imageName = isAgree ? "select" : "normal"
            self.termsButton.setImage(UIImage(named: imageName), for: .normal)
            validate()
        }
        
        viewModel?.agreeClosure = { [weak self] isAgree in
            guard let self else { return }
            let imageName = isAgree ? "select" : "normal"
            self.agreeButton.setImage(UIImage(named: imageName), for: .normal)
            validate()
        }
        
        viewModel?.purchaseClosure = { [weak self] success, message in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                if success {
                    let successView = PurchaseSuccessView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
                    successView.setContent(endDate: message, amount: self.viewModel?.amount ?? 0)
                    successView.confirmClosure = {
                        if let vcArr = self.navigationController?.viewControllers {
                            self.navigationController?.popToViewController(vcArr[0], animated: true)
                        }
                    }
                    self.view.addSubview(successView)
                }else {
                    CustomAlertView.shared.showMe(message: message)
                }
            }
        }
        
    }
    
//MARK: - action
    func validate() {
        if (viewModel?.isAgree ?? false && viewModel?.isTerms ?? false && viewModel?.availableBalance ?? 0 >= 0) {
            nextButton.updateButton(isNext: true)
        }else{
            nextButton.updateButton(isNext: false)
        }
    }
    
    @objc func agreeButtonClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if (btn == termsButton) {
            viewModel?.isTerms = btn.isSelected
        }else {
            viewModel?.isAgree = btn.isSelected
        }
    }

    @objc func nextClick() {
        if let memberInfo = GC.getMemberInfo() {
            if memberInfo.isGaEnabled {
                TwofaAlertView.shared.showInView { code in
                    let paramates: [String: Any] = ["userId": memberInfo.id ?? "", "verificationCode": code, "productId": self.viewModel?.productId ?? "", "amount": self.viewModel?.amount ?? 0, "autoRenewEnabled": true]
                    self.viewModel?.addContract(paramates: paramates)
                    HUD.show(.systemActivity, onView: self.view)
                }
            }else {
                CustomAlertView.shared.showMe(message: "未開啟兩步驟驗證。")
            }
        }
    }
    
}
