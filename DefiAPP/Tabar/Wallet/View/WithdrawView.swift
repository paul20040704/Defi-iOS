//
//  WithdrawView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/21.
//

import UIKit
import PKHUD

class WithdrawView: UIView, NibOwnerLoadable {
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var maxButton: UIButton!
    
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var actuallyLabel: UILabel!
    
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var walletVC: WalletVC?
    
    var withdrawClosure: VoidClosure?
    
    var viewModel: WalletViewModel? {
        didSet {
            self.observeEvent()
        }
    }
    //輸入提現金額
    var amount: Double = 0.0 {
        didSet {
            self.countActually()
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
        addressTextField.addTarget(self, action: #selector(observeTextField), for: .editingChanged)
        amountTextField.keyboardType = .decimalPad
        amountTextField.addTarget(self, action: #selector(observeTextField), for: .editingChanged)
        maxButton.addTarget(self, action: #selector(maxClick), for: .touchUpInside)
        nextButton.updateButton(isNext: false)
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }
    
    func observeEvent() {
        viewModel?.assetTypeClosure = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.minLabel.text = "最低提領金額：\(self.viewModel?.assetTypeInfo.minimumWithdraw ?? 0) USDT"
                self.maxLabel.text = "每次提領上限：\(self.viewModel?.assetTypeInfo.maximumWithdraw ?? 0) USDT"
                self.feeLabel.text = "\(self.viewModel?.assetTypeInfo.withdrawFee ?? 0) USDT"
            }
        }
        viewModel?.getAssetType()
        
        viewModel?.withdrawClosure = { [weak self] success, message in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                if success {
                    CustomAlertView.shared.showMe(title: "提幣完成", message: "您已成功提幣！")
                    self.addressTextField.text = ""
                    self.amountTextField.text = ""
                    self.amount = 0
                    self.withdrawClosure?()
                    self.nextButton.updateButton(isNext: false)
                }else {
                    CustomAlertView.shared.showMe(message: message)
                }
            }
        }
        
    }
    
    //計算實際獲得金額
    func countActually() {
        //let amount = Double(amountTextField.text ?? "0") ?? 0
        let actually = self.amount - Double(viewModel?.assetTypeInfo.withdrawFee ?? 0)
        self.actuallyLabel.text = actually >= 0 ? "\(actually.rounded(toPlaces: 2)) USDT" : "0 USDT"
    }
    
    //MARK: - action
    @objc func observeTextField() {
        self.amount = Double(amountTextField.text ?? "0") ?? 0
        if (Double(viewModel?.balanceData?.balance ?? 0) >= amount && amount >= viewModel?.assetTypeInfo.minimumWithdraw ?? 0 && amount <= viewModel?.assetTypeInfo.maximumWithdraw ?? 0 && addressTextField.text?.count ?? 0 > 0)  {
            nextButton.updateButton(isNext: true)
        }else {
            nextButton.updateButton(isNext: false)
        }
    }
    
    @objc func maxClick() {
        amountTextField.text = "\(viewModel?.balanceData?.balance ?? 0)"
        amount = Double(viewModel?.balanceData?.balance ?? 0)
        self.observeTextField()
    }
    
    @objc func nextClick() {
        if let memberInfo = GC.getMemberInfo() {
            if memberInfo.isGaEnabled {
                let withdrawAlertView = WithdrawAlertView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
                withdrawAlertView.setContent(address: addressTextField.text ?? "", amount: amount, fee: viewModel?.assetTypeInfo.withdrawFee ?? 0)
                withdrawAlertView.confirmClosure = {
                    TwofaAlertView.shared.showInView { code in
                        let paramaters: [String: Any] = ["userId": memberInfo.id ?? "", "verificationCode": code, "chain": "Ethereum" , "asset": "USDT", "amount": self.amount, "to": self.addressTextField.text ?? ""]
                        self.viewModel?.withdraw(paramaters: paramaters)
                        HUD.show(.systemActivity, onView: self)
                    }
                }
                self.walletVC?.view.addSubview(withdrawAlertView)
            }else {
                CustomAlertView.shared.showMe(message: "未開啟兩步驟驗證。")
            }
        }
    }
    
}
