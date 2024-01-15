//
//  XCUIElementEx.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/12/18.
//

import Foundation
import XCTest

extension XCUIElement {
    func clearText() {
        tap()
        press(forDuration: 1.0)
        typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 30))
    }
    
    
    
    
}

