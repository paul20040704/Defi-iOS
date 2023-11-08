//
//  ForgotVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import UIKit

class ForgotVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var validTextField: UITextField!
    @IBOutlet weak var validButton: CustomNextButton!
    
    @IBOutlet weak var newPwTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var showConfirmButton: UIButton!
    
    @IBOutlet weak var nextButton: CustomNextButton!
    
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.navigationItem.title = "忘記密碼"
        
        emailTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        validTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        newPwTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        confirmPwTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        
        showButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
        showConfirmButton.addTarget(self, action: #selector(passwordVisibleBtnClick(_:)), for: .touchUpInside)
    }

    @objc func validateFields() {
        let isEmailValid = emailTextField.text?.validateEmail() ?? false
        let isCodeValid = (validTextField.text ?? "").isEmpty ? false : true
        let isNewPwValid = newPwTextField.text?.validatePassword() ?? false
        let isConfirmPwValid = confirmPwTextField.text?.validatePassword() ?? false
        
        validButton.updateButton(isNext: isEmailValid)
        
        if isNewPwValid && isConfirmPwValid && isCodeValid && (newPwTextField.text == confirmPwTextField.text) {
            nextButton.updateButton(isNext: true)
        }else {
            nextButton.updateButton(isNext: false)
        }
    }
    
    //MARK: - action
    
    @objc func passwordVisibleBtnClick(_ btn: UIButton) {
        if btn == showButton {
            showButton.togglePasswordVisibility(textField: newPwTextField)
        }else {
            showConfirmButton.togglePasswordVisibility(textField: confirmPwTextField)
        }
    }
    
    
    @objc func resetClick() {
        
    }

}
