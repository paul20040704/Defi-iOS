//
//  DepositView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/21.
//

import UIKit
import PKHUD

class DepositView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var qrcodeImage: UIImageView!
    
    @IBOutlet weak var copyButton: UIButton!
    
    var viewModel: WalletViewModel?
    
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
        if let memeberInfo = GC.getMemberInfo() {
            self.addressLabel.text = memeberInfo.wallets?[0].address ?? ""
            self.qrcodeImage.image = QRCodeManager.generateQRCode(from: memeberInfo.wallets?[0].address ?? "")
        }
        copyButton.addTarget(self, action: #selector(copyClick), for: .touchUpInside)
    }
    
    @objc func copyClick() {
        UIPasteboard.general.string = addressLabel.text
        HUD.flash(.label("複製成功"), delay: 1.0)
    }

}
