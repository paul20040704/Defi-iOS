//
//  SelectAlertView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/9.
//

import UIKit

class SelectAlertView: UIView, NibOwnerLoadable {
    static let shared = SelectAlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
   
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var okAction: (()->())?
    //var cancelAction: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SelectAlertView", owner: self)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        parentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        parentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        confirmButton.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
    }
    
    
    func showInView(title: String = "你好", message: String, okAction: (()->())?) {
        self.okAction = okAction
        //self.cancelAction = cancel
        self.titleLabel.text = title
        self.contentLabel.text = message
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.addSubview(parentView)
            }
        }
    }
    
    @objc func confirmClick() {
        parentView.removeFromSuperview()
        self.okAction?()
    }
    
    @objc func cancelClick() {
        parentView.removeFromSuperview()
        //self.cancelAction?()
    }
    
    
}
