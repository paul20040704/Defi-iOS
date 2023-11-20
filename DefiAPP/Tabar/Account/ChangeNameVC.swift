//
//  ChangeNameVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/14.
//

import UIKit
import PKHUD

class ChangeNameVC: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel = MemberViewModel()
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        observeEvent()
    }
    

    func setUI() {
        self.navigationItem.title = "編輯使用者名稱"
        userTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        userTextField.placeholder = userName
        nextButton.updateButton(isNext: false)
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }
    
    func observeEvent() {
        viewModel.changeUserClosure = { success, message in
            DispatchQueue.main.async {
                HUD.hide()
                if success {
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
        nextButton.updateButton(isNext: userTextField.text?.count ?? 0 > 0)
    }

    @objc func nextClick() {
        if let memberInfo = GC.getMemberInfo() {
            HUD.show(.systemActivity, onView: self.view)
            let paramates: [String: Any] = ["userId": memberInfo.id ?? "", "nickname": userTextField.text ?? ""]
            viewModel.changUserName(paramates: paramates)
        }
    }
    
}
