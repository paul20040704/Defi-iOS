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
    }

}
