//
//  WalletCollectionCell.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/12/4.
//

import UIKit

class WalletCollectionCell: UICollectionViewCell {
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var assetLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var lockLabel: UILabel!
    
    func setup(data: WalletData, isHide: Bool) {
        self.coinImageView.image = UIImage(named: data.symbol ?? "")
        self.totalLabel.text = isHide ? "\((data.balance ?? 0) + (data.lockedBalance ?? 0))" : "***"
        self.assetLabel.text = data.symbol ?? ""
        self.availableLabel.text = isHide ? "可用\(data.balance ?? 0)" : "可用***"
        self.lockLabel.text = isHide ? "鎖倉 \(data.lockedBalance ?? 0)" : "鎖倉***"
    }
    
}
