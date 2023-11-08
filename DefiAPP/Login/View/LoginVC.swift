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
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        showPasswordButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        keepButton.addTarget(self, action: #selector(keepAccountClick(_:)), for: .touchUpInside)
        forgotButton.addTarget(self, action: #selector(goForgot), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        registerButton.addTarget(self, action: #selector(goRegister), for: .touchUpInside)
    }
    
    //MARK: - observe
    func observeEvent() {
        loginViewModel.loginResult = { [weak self] result, message in
            guard let self else { return }
            if result {
                DispatchQueue.main.async {
                    GC.goMain()
                }
                print("login success")
            }else {
                print(message)
            }
        }
        
        loginViewModel.updateKeepAccount = { [weak self] keepAccount in
            guard let self else { return }
            self.emailTextField.text = keepAccount
        }
        
        loginViewModel.updateKeepButton = { [weak self] isKeep in
            guard let self else { return }
            let imageName = isKeep ? "select" : "normal"
            self.keepButton.setImage(UIImage(named: imageName), for: .normal)
            self.keepButton.isSelected = isKeep
        }
        
        loginViewModel.judgeKeep()
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
        loginViewModel.isKeepAccount = btn.isSelected
    }
    
    @objc func login() {
        let parameters : [String: Any] = ["email": emailTextField.text ?? "", "password": passwordTextField.text ?? ""]
        loginViewModel.login(loginInfo: parameters)
    }
    
    @objc func goRegister() {
        let registerVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC")
        self.navigationController?.show(registerVC, sender: nil)
    }
    

}


extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
