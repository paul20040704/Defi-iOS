//
//  PurchaseSuccessView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/16.
//

import UIKit

class PurchaseSuccessView: UIView, NibOwnerLoadable {

    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nextButton: CustomNextButton!
    
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
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }
    
    func setContent(endDate: String, amount: Double) {
        endDateLabel.text = endDate
        amountLabel.text = "\(amount) USDT"
    }
    
    @objc func nextClick() {
        self.confirmClosure?()
    }

}
