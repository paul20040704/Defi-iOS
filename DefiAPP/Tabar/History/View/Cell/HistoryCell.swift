//
//  HistoryCell.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/17.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var duringLabel: UILabel!
    @IBOutlet weak var aprLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(productData: ItemsData) {
        self.amountLabel.text = "申購金額 \(productData.amount ?? 0) \(productData.product.asset ?? "USDT")"
        self.duringLabel.text = "期間 \(productData.product.period.length ?? 3) 個月"
        self.aprLabel.text = "\(productData.product.apr ?? 0)%"
        if let status = productData.statuses[0].status, let reason = productData.statuses[0].reason {
            if status == "Effective" {
                self.statusLabel.text = "進行中"
                self.statusLabel.backgroundColor = UIColor(hex: "#EDFAF4")
            }else {
                self.statusLabel.text = reason
                self.statusLabel.backgroundColor = UIColor(hex: "#F48686")
            }
        }
    }
    
}
