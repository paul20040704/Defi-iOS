//
//  ChangePasswordVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/14.
//

import UIKit
import PKHUD

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordButton: UIButton!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel = SafetyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        observeEvent()
    }
    
    func setUI() {
        self.navigationItem.title = "更換密碼"
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        newPasswordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        confirmTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        newPasswordButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
        nextButton.updateButton(isNext: false)
    }

    func observeEvent() {
        viewModel.changePwClosure = { [weak self] result, message in
            guard let self else { return }
            DispatchQueue.main.sync {
                if result {
                    CustomAlertView.shared.showMe(title: "提醒", message: "密碼變更成功")
                    if let vcArr = self.navigationController?.viewControllers {
                        self.navigationController?.popToViewController(vcArr[0], animated: true)
                    }
                }else {
                    CustomAlertView.shared.showMe(message: message)
                }
            }
        }
    }
    
    //MARK: - action
    @objc func validateFields() {
        let isEmailValid = passwordTextField.text?.validatePassword() ?? false
        let isPwValid = newPasswordTextField.text?.validatePassword() ?? false
        let isConfirmPwValid = confirmTextField.text?.validatePassword() ?? false
        
        if isEmailValid && isPwValid && isConfirmPwValid && (newPasswordTextField.text == confirmTextField.text) {
            nextButton.updateButton(isNext: true)
        }else {
            nextButton.updateButton(isNext: false)
        }
    }
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        if btn == newPasswordButton {
            newPasswordButton.togglePasswordVisibility(textField: newPasswordTextField)
        }else {
            confirmButton.togglePasswordVisibility(textField: confirmTextField)
        }
    }

    @objc func nextClick() {
        if let memberInfo = GC.getMemberInfo() {
            var paramaters: [String: Any] = ["email": memberInfo.email ?? "", "password": passwordTextField.text ?? "" , "newPassword": newPasswordTextField.text ?? ""]
            if memberInfo.isGaEnabled {
                TwofaAlertView.shared.showInView { code in
                    paramaters["verificationCode"] = code
                    self.viewModel.changPassword(paramates: paramaters)
                }
            }else {
                viewModel.changPassword(paramates: paramaters)
            }
        }
    }

}
