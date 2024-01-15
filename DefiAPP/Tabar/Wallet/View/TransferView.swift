//
//  TransferView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/21.
//

import UIKit
import PKHUD

class TransferView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var maxButton: UIButton!
    @IBOutlet weak var actuallyLabel: UILabel!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel: WalletViewModel? {
        didSet {
            self.observeEvent()
        }
    }
    
    //輸入提現金額
    var amount: Double = 0.0 {
        didSet {
            self.actuallyLabel.text = "\(amount) USDT"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        commonInit()
    }
    
    func loadXib() {
        loadNibContent()
    }
    
    func commonInit() {
        idTextField.addTarget(self, action: #selector(observeTextField), for: .editingChanged)
        amountTextField.addTarget(self, action: #selector(observeTextField), for: .editingChanged)
        amountTextField.keyboardType = .decimalPad
        maxButton.addTarget(self, action: #selector(maxClick), for: .touchUpInside)
        nextButton.updateButton(isNext: false)
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }

    func observeEvent() {
        NotificationCenter.default.post(name: .walletNotification, object: nil)
    }
    
    //MARK: - action
    @objc func observeTextField() {
        self.amount = Double(amountTextField.text ?? "0") ?? 0
        actuallyLabel.text = "\(self.amount) USDT"
        if (Double(viewModel?.balanceDatas[0].balance ?? 0) >= self.amount && idTextField.text?.count ?? 0 > 0)  {
            nextButton.updateButton(isNext: true)
        }else {
            nextButton.updateButton(isNext: false)
        }
    }
    
    @objc func maxClick() {
        amountTextField.text = "\(viewModel?.balanceDatas[0].balance ?? 0)"
        self.amount = Double(viewModel?.balanceDatas[0].balance ?? 0)
        self.observeTextField()
    }
    
    @objc func nextClick() {
        if let memberInfo = UserDefaultsManager.shared.memberInfo {
            if memberInfo.isGaEnabled {
                let withdrawAlertView = WithdrawAlertView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
                withdrawAlertView.setContent(address: idTextField.text ?? "", amount: amount, fee: 0)
                withdrawAlertView.confirmClosure = {
                    TwofaAlertView.shared.showInView { code in
                        let paramaters: [String: Any] = ["userId": memberInfo.id ?? "", "verificationCode": code, "toUserId": self.idTextField.text ?? "", "chain": "Ethereum" , "asset": "USDT", "amount": self.amount]
                        self.viewModel?.transferUser(paramaters: paramaters)
                        HUD.show(.systemActivity, onView: self)
                    }
                }
                self.viewModel?.walletVC?.view.addSubview(withdrawAlertView)
            }else {
                CustomAlertView.shared.showMe(message: "未開啟兩步驟驗證。")
            }
        }
    }
    
}
