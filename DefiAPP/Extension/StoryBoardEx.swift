//
//  StoryBoardEx.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/10/30.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if (newValue > 0) {
                if (newValue > (self.frame.height / 2)) {
                    layer.cornerRadius = self.frame.height / 2
                } else {
                    layer.cornerRadius = newValue
                }
                layer.masksToBounds = true
                clipsToBounds = true
            } else {
                layer.cornerRadius = newValue
                layer.masksToBounds = false
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}
