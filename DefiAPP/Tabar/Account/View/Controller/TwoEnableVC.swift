//
//  TwoEnableVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/10.
//

import UIKit
import PKHUD

class TwoEnableVC: UIViewController {

    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var gakeyLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel = TwoFAViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "兩步驟驗證"
        
        setUI()
        observeEvent()
    }
    

    func setUI() {
        nextButton.updateButton(isNext: false)
        
        codeTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        copyButton.addTarget(self, action: #selector(copyBtnClick), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }

    func observeEvent() {
        HUD.show(.systemActivity, onView: self.view)
        viewModel.updateGaKey = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                self.qrcodeImage.image = QRCodeManager.imageUrlToQrcode(from: self.viewModel.gaData.qrCodeSetupImageUrl ?? "")
                self.gakeyLabel.text = self.viewModel.gaData.manualEntryKey ?? ""
            }
        }
        
        viewModel.putGaResult = { [weak self] success, message in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                if success {
                    if let vcArr = self.navigationController?.viewControllers {
                        self.navigationController?.popToViewController(vcArr[2], animated: true)
                    }
                }else {
                    CustomAlertView.shared.showMe(message: message)
                }
            }
        }
        
        viewModel.getGaKey()
    }
    
//MARK: - action
    @objc func copyBtnClick() {
        UIPasteboard.general.string = gakeyLabel.text
        HUD.flash(.label("複製成功"), delay: 1.0)
    }
    
    @objc func validateFields() {
        nextButton.updateButton(isNext: codeTextField.text?.count ?? 0 > 5)
    }
    
    @objc func nextClick() {
        if let memberInfo = UserDefaultsManager.shared.memberInfo {
            HUD.show(.systemActivity, onView: self.view)
            let parameters : [String: Any] = ["userId": memberInfo.id ?? "", "verificationCode": codeTextField.text ?? "", "enabled": true]
            viewModel.putGaEnable(paramates: parameters)
        }
    }
    
}
