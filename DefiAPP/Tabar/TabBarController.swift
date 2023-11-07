//
//  TabBarController.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let purchaseVC = UIStoryboard(name: "Purchase", bundle: nil).instantiateViewController(withIdentifier: "PurchaseVC")
        
        //let purchaseVC = UIStoryboard(name: "Purchase", bundle: nil).instantiateViewController(withIdentifier: "PurchaseDetailVC")
        
        let historyVC = UIStoryboard(name: "History", bundle: nil).instantiateViewController(withIdentifier: "HistoryVC")
        
        let walletVC = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: "WalletVC")
        
        let accountVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "AccountVC")
        
        self.setViewControllers([purchaseVC, historyVC, walletVC, accountVC], animated: false)
        
        self.tabBar.tintColor = UIColor.init(hex: "#5ABA81") // 選中的顏色
        self.tabBar.unselectedItemTintColor = UIColor.init(hex: "#575757") // 沒選中的顏色
        self.tabBar.barTintColor = UIColor.init(hex: "#FFFFFF") // TabBar背景顏色
        
        self.navigationItem.backButtonTitle = ""
        
        getToken()
    }
    
    func getToken() {
        if let token = UD.string(forKey: "token") {
            print("token -- \(token)")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
