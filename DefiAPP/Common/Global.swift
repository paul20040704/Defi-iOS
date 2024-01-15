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

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

typealias VoidClosure = () -> ()
typealias BoolClosure = (Bool) -> ()
typealias StringClosure = (String) -> ()
typealias MessageClosure = (_ result: Bool,_ message: String) ->()
