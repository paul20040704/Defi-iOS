//
//  CustomAlertView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/9.
//

import UIKit

class CustomAlertView: UIView {
    
    static let shared = CustomAlertView()
    
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: CustomNextButton!
    @IBOutlet weak var textView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CustomAlertView", owner: self)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commitInit() {
        parentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        parentView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }
    
    func showMe(title: String = "出錯了",message: String) {
        titleLabel.text = title
        textView.text = message
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.addSubview(parentView)
            }
        }
    }
    
    @objc func nextClick() {
        parentView.removeFromSuperview()
    }
    
}
