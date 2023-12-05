//
//  SwapAlertView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/12/5.
//

import UIKit

class SwapAlertView: UIView, NibOwnerLoadable {
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var feePercentLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var actuallyLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var confirmClosure: VoidClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        loadNibContent()
        commonInit()
    }
    
    func commonInit() {
        confirmButton.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
    }
    
    func setContent(data: SwapQuotationData?) {
        self.groupLabel.text = "\(data?.fromCryptocurrencySymbol ?? "") -> \(data?.toCryptocurrencySymbol ?? "")"
        self.amountLabel.text = "\(data?.fromCryptocurrencyAmount ?? 0) \(data?.fromCryptocurrencySymbol ?? "")"
        self.rateLabel.text = "\(data?.rate ?? 0)"
        self.feePercentLabel.text = "\(data?.systemFeePercentage ?? 0) %"
        self.feeLabel.text = "\(data?.systemFee ?? 0) \(data?.toCryptocurrencySymbol ?? "")"
        self.actuallyLabel.text = "\(data?.toCryptocurrencyAmount ?? 0) \(data?.toCryptocurrencySymbol ?? "")"
    }
    
    @objc func confirmClick() {
        self.confirmClosure?()
        self.removeFromSuperview()
    }
    
    @objc func cancelClick() {
        self.removeFromSuperview()
    }
    
}
