//
//  TwoPauseVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/13.
//

import UIKit
import PKHUD

class TwoPauseVC: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel = TwoFAViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        observeEvent()
       
    }
    

    func setUI() {
        self.navigationItem.title = "兩步驟驗證"
        codeTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        nextButton.updateButton(isNext: false)
    }

    func observeEvent() {
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
    }
    
    //MARK: - action
        @objc func validateFields() {
            nextButton.updateButton(isNext: codeTextField.text?.count ?? 0 > 5)
        }
        
        @objc func nextClick() {
            if let memberInfo = GC.getMemberInfo() {
                HUD.show(.systemActivity, onView: self.view)
                let parameters : [String: Any] = ["userId": memberInfo.id ?? "", "verificationCode": codeTextField.text ?? "", "enabled": false]
                viewModel.putGaEnable(paramates: parameters)
            }
        }
        

}
