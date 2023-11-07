//
//  ProductCell.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/2.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var highestLabel: UILabel!
    @IBOutlet weak var aprLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(productData: ProductData) {
        self.highestLabel.text = "最高\(productData.apr ?? 0)%"
        self.aprLabel.text = "\(productData.apr ?? 0)"
        self.periodLabel.text = "\(productData.period.length ?? 0)個月"
    }
    
}
