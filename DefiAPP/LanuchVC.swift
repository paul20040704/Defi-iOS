//
//  LanuchVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/8.
//

import UIKit

class LanuchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        judgeToken()
    }
    
    func judgeToken() {
        let expTime = UD.integer(forKey: "expTime")
        let nowTime = GC.getTimeInterval()
        if expTime > nowTime {
            if let _ = UD.string(forKey: "token") {
                GC.goMain()
            }else {
                GC.goLogin()
            }
        }else {
            GC.goLogin()
        }
    }
    

}
