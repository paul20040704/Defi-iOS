//
//  DetailView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/6.
//

import UIKit

class DetailView: UIView {
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    var productData: ProductData? {
        didSet {
            self.minLabel.text = "\(productData?.minumumAmount ?? 0) USDT"
            self.startDateLabel.text = productData?.subscriptionStartDate ?? ""
            self.endDateLabel.text = productData?.subscriptionEndDate ?? ""
            self.assetLabel.text = productData?.asset ?? ""
            self.maxLabel.text = "\(productData?.maximumAmount ?? 0) USDT"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DetailView", bundle: bundle)
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(xibView)
    }
    
    

}
