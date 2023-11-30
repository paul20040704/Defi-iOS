//
//  TwofaAlertView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/16.
//

import UIKit

class TwofaAlertView: UIView {
    static let shared = TwofaAlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var okAction: StringClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("TwofaAlertView", owner: self)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        parentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        parentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        codeTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        nextButton.updateButton(isNext: false)
    }
    
    func showInView(okAction: StringClosure?) {
        self.okAction = okAction
        self.codeTextField.text = ""
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.addSubview(parentView)
            }
        }
    }
    
    @objc func validateFields() {
        nextButton.updateButton(isNext: codeTextField.text?.count ?? 0 > 0)
    }
    
    @objc func confirmClick() {
        self.okAction?(codeTextField.text ?? "")
        parentView.removeFromSuperview()
    }
    
    @objc func cancelClick() {
        parentView.removeFromSuperview()
    }
    

}
