//
//  WalletHistoryCell.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/28.
//

import UIKit

class WalletHistoryCell: UITableViewCell {

    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var purposeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(data: LedgerData?) {
        if let data = data {
            self.assetLabel.text = data.asset ?? ""
            self.amountLabel.text = "\(data.amount ?? 0)"
            self.amountLabel.textColor = data.amount ?? 0 >= 0 ? .black : .red
            self.statusLabel.text = data.status ?? ""
            self.purposeLabel.text = data.purpose ?? ""
        }
    }
    
}
