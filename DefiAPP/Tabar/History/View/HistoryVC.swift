//
//  InvestVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var managementButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    @IBOutlet weak var nextButton: CustomNextButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        setUI()
    }
    
    func setUI() {
        managementButton.changeLayer(isSelect: true)
        managementButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        
    }

    //MARK: - Action
    @objc func selectClick(_ btn: UIButton) {
        if btn.tag == 0 {
            managementButton.changeLayer(isSelect: true)
            historyButton.changeLayer(isSelect: false)
        }else {
            managementButton.changeLayer(isSelect: false)
            historyButton.changeLayer(isSelect: true)
        }
    }

}
