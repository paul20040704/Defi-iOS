//
//  SwapView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/30.
//

import UIKit
import PKHUD

class SwapView: UIView, NibOwnerLoadable {

    @IBOutlet weak var usdtLabel: UILabel!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var dsfLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var maxButton: UIButton!
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel: WalletViewModel? {
        didSet {
            self.observeEvent()
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
        swapButton.addTarget(self, action: #selector(swapClick), for: .touchUpInside)
        amountTextField.delegate = self
        amountTextField.keyboardType = .decimalPad
        amountTextField.addTarget(self, action: #selector(observeTextField), for: .editingChanged)
        maxButton.addTarget(self, action: #selector(maxClick), for: .touchUpInside)
        nextButton.updateButton(isNext: false)
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }
    
    func observeEvent() {
        viewModel?.selectSwapClosure = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.swapButton.setImage(UIImage(systemName: self.viewModel?.fromSymbol == "USDT" ? "arrowshape.down.fill" : "arrowshape.up.fill"), for: .normal)
                self.currencyLabel.text = self.viewModel?.fromSymbol ?? ""
                self.amountTextField.text = ""
                self.observeTextField()
            }
        }
        
        viewModel?.getSwapInfo()
        
        viewModel?.swapQuotaionClosure = { [weak self] success, message in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                let swapAlertView = SwapAlertView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
                swapAlertView.setContent(data: self.viewModel?.swapQuotationData ?? nil)
                swapAlertView.confirmClosure = {
                    self.viewModel?.postSwap(paramaters: ["swapId": self.viewModel?.swapQuotationData.swapId ?? 0, "swapQuotationId": self.viewModel?.swapQuotationData.swapQuotationId ?? ""])
                    HUD.show(.systemActivity, onView: self)
                }
                self.viewModel?.walletVC?.view.addSubview(swapAlertView)
            }
        }
        
        viewModel?.swapClosure = { [weak self] success, message in
            guard let self else { return }
            DispatchQueue.main.async {
                if success {
                    HUD.hide()
                    CustomAlertView.shared.showMe(title: "兌幣完成", message: "您已成功兌幣！")
                    self.amountTextField.text = ""
                    self.observeTextField()
                    NotificationCenter.default.post(name: .walletNotification, object: nil)
                }else {
                    CustomAlertView.shared.showMe(message: message)
                }
            }
        }
        
    }
    
    //MARK: - action
    @objc func observeTextField() {
        let amount = Double(amountTextField.text ?? "0") ?? 0
        let swapData = viewModel?.swapInfoDic[viewModel?.fromSymbol ?? ""]
        self.usdtLabel.text = viewModel?.fromSymbol == "USDT" ? "\(amount) USDT" : "\(amount.countByRate(rate: swapData?.rate ?? 0, decimal: swapData?.fromCryptocurrencyDecimal ?? 6)) USDT"
        self.dsfLabel.text = viewModel?.fromSymbol == "DSF" ? "\(amount) DSF" : "\(amount.countByRate(rate: swapData?.rate ?? 0, decimal: swapData?.fromCryptocurrencyDecimal ?? 6)) DSF"
        
        self.nextButton.updateButton(isNext: false)
        self.remindLabel.isHidden = false
        if amount > swapData?.fromCryptocurrencyMaxAmount ?? 0 {
            self.remindLabel.text = "大於最大金額"
        }else if amount < swapData?.fromCryptocurrencyMinAmount ?? 0 {
            self.remindLabel.text = "小於最小金額"
        }else if amount > swapData?.fromCryptocurrencyBalance ?? 0 {
            self.remindLabel.text = "超過目前擁有餘額"
        }else {
            self.remindLabel.isHidden = true
            self.nextButton.updateButton(isNext: true)
        }
        
    }
    
    @objc func swapClick() {
        viewModel?.fromSymbol = viewModel?.fromSymbol == "USDT" ? "DSF" : "USDT"
    }
    
    @objc func maxClick() {
        let balance = viewModel?.swapInfoDic[viewModel?.fromSymbol ?? ""]?.fromCryptocurrencyBalance ?? 0
        self.amountTextField.text = "\(balance)"
        self.observeTextField()
    }
    
    @objc func nextClick() {
        HUD.show(.systemActivity, onView: self)
        let paramaters: [String: Any] = ["swapId": viewModel?.swapInfoDic[viewModel?.fromSymbol ?? ""]?.swapId ?? 0, "fromCryptocurrencyAmount": Double(amountTextField.text ?? "0") ?? 0]
        viewModel?.getSwapQuotaion(paramaters: paramaters)
    }
    
}

extension SwapView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField {
            // 檢查輸入的字元是否是數字或小數點
            let decimal = viewModel?.swapInfoDic[viewModel?.fromSymbol ?? ""]?.fromCryptocurrencyDecimal ?? 6
            //檢查小數點位數
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let components = newText.components(separatedBy: ".")
            if components.count > 2 {
                return false
            }
            
            if components.count == 1 && components.first?.count ?? 0 < 10 {
                return true
            }
                
            //檢查小數點後的位數
            if let lastComponent = components.last, lastComponent.count > decimal {
                return false
            }
        }
        return true
    }
    
}
