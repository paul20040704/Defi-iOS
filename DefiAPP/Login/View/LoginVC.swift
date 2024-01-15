//
//  LoginVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/10/30.
//

import UIKit
import PKHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    @IBOutlet weak var keepButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        observeEvent()
    }
    
    func setUI() {
        self.navigationItem.backButtonTitle = ""
        
        emailTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        emailTextField.text = UserDefaultsManager.shared.keepAccount
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        
        showPasswordButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        keepButton.addTarget(self, action: #selector(keepAccountClick(_:)), for: .touchUpInside)
        keepButton.setImage(UIImage(named: UserDefaultsManager.shared.isKeepAccount ? "select" : "normal"), for: .normal)
        forgotButton.addTarget(self, action: #selector(goForgot), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        registerButton.addTarget(self, action: #selector(goRegister), for: .touchUpInside)
        
        nextButton.updateButton(isNext: false)
    }
    
    //MARK: - observe
    func observeEvent() {
        loginViewModel.loginResult = {[weak self] result, message in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                if result {
                    if message == "goTwofa" {
                        TwofaAlertView.shared.showInView { code in
                            self.loginWithCode(code: code)
                        }
                    }else {
                        GC.goMain()
                    }
                }else {
                    CustomAlertView.shared.showMe(message: message)
                }
            }
        }
        
        loginViewModel.updateKeepButton = { [weak self] isKeep in
            guard let self else { return }
            let imageName = isKeep ? "select" : "normal"
            self.keepButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
   
    //MARK: - action
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
        loginViewModel.keepButtonClick()
    }
    
    @objc func login() {
        let parameters : [String: Any] = ["email": emailTextField.text ?? "", "password": passwordTextField.text ?? ""]
        loginViewModel.login(loginInfo: parameters)
        HUD.show(.systemActivity, onView: self.view)
    }
    
    @objc func goRegister() {
        let registerVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC")
        self.navigationController?.show(registerVC, sender: nil)
    }
    
    func loginWithCode(code: String) {
        HUD.show(.systemActivity, onView: self.view)
        let parameters : [String: Any] = ["email": emailTextField.text ?? "", "password": passwordTextField.text ?? "", "verificationCode": code]
        loginViewModel.login(loginInfo: parameters)
    }
    

}

