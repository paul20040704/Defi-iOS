//
//  Global.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import Foundation
import UIKit

let NS = NetworkManager.shared

let GC = GlobalFunc.shared

let UD = UserDefaults.standard

enum UserDefaultsKey: String {
    case token
    case expTime
    case isKeepAccount
    case keepAccount
    case memberInfo
    case faceID
}

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

typealias VoidClosure = () -> ()
typealias BoolClosure = (Bool) -> ()
typealias StringClosure = (String) -> ()
typealias MessageClosure = (_ result: Bool,_ message: String) ->()
