//
//  RegisterVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/8.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var showConfirmButton: UIButton!
    
    @IBOutlet weak var referralTextField: UITextField!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "註冊"
        setUI()
        observeEvent()
    }
    
    func setUI() {
        emailTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        confirmTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        
        showButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        showConfirmButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        
        nextButton.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
        nextButton.updateButton(isNext: false)
    }
    
    func observeEvent() {
        loginViewModel.registerResult = { result, message in
            if result {
                DispatchQueue.main.async {
                    //註冊成功
                    if let vcArr = self.navigationController?.viewControllers {
                        self.navigationController?.popToViewController(vcArr[0], animated: true)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    CustomAlertView.shared.showMe(message: message)
                }
                print(message)
            }
        }
    }

    @objc func validateFields() {
        let isEmailValid = emailTextField.text?.validateEmail() ?? false
        let isPwValid = passwordTextField.text?.validatePassword() ?? false
        let isConfirmPwValid = confirmTextField.text?.validatePassword() ?? false
        
        if isEmailValid && isPwValid && isConfirmPwValid && (passwordTextField.text == confirmTextField.text) {
            nextButton.updateButton(isNext: true)
        }else {
            nextButton.updateButton(isNext: false)
        }
    }
    
    //MARK: - action
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        if btn == showButton {
            showButton.togglePasswordVisibility(textField: passwordTextField)
        }else {
            showConfirmButton.togglePasswordVisibility(textField: confirmTextField)
        }
    }
    
    @objc func registerClick() {
        let parameters : [String: Any] = ["email": emailTextField.text ?? "", "password": passwordTextField.text ?? "", "refererId": referralTextField.text ?? ""]
        
        loginViewModel.register(loginInfo: parameters)
    }

}
