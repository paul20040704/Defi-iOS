//
//  LoginVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/10/30.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var keepButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        observeEvent()
    }
    
    func setUI() {
        self.navigationItem.backButtonTitle = ""
        
        emailTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        showPasswordButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        keepButton.addTarget(self, action: #selector(keepAccountClick(_:)), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(goForgot), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    func observeEvent() {
        loginViewModel.loginResult = { result, message in
            if result {
                DispatchQueue.main.async {
                    GC.goMain()
                }
                print("login success")
            }else {
                print(message)
            }
        }
    }
    
    @objc func validateFields() {
        let isEmailValid = emailTextField.text?.validateEmail() ?? false
        let isPasswordValid = passwordTextField.text?.validatePassword() ?? false
        if isEmailValid && isPasswordValid {
            nextButton.updateButton(isNext: true)
        }else {
            nextButton.updateButton(isNext: false)
        }
    }

    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        btn.togglePasswordVisibility(textField: passwordTextField)
    }
    
    @objc func goForgot() {
        let forgotVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ForgotVC")
        self.navigationController?.show(forgotVC, sender: nil)
    }
    
    @objc func keepAccountClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        let imageName = btn.isSelected ? "select" : "normal"
        btn.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @objc func login() {
        let parameters : [String: Any] = ["email": emailTextField.text ?? "", "password": passwordTextField.text ?? ""]
        loginViewModel.login(loginInfo: parameters)
    }
    

}
