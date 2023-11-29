//
//  WithdrawAlertView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/22.
//

import UIKit

class WithdrawAlertView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
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
    
    func setContent(address: String, amount: Double, fee: Double) {
        addressLabel.text = address
        amountLabel.text = "\(amount) USDT"
        feeLabel.text = "\(fee) USDT"
        actuallyLabel.text = "\(amount - fee) USDT"
    }
    
    @objc func confirmClick() {
        self.confirmClosure?()
        self.removeFromSuperview()
    }
    
    @objc func cancelClick() {
        self.removeFromSuperview()
    }
}
