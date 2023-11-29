//
//  WalletVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/6.
//

import UIKit

class WalletVC: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet var selectionButttons: [UIButton]!
    
    @IBOutlet weak var depositView: DepositView!
    @IBOutlet weak var withdrawView: WithdrawView!
    @IBOutlet weak var transferView: TransferView!
    @IBOutlet weak var historyView: HistoryView!
    
    var viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
        observeEvent()
        setupSubView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setUI() {
        self.navigationItem.title = "錢包"
        selectionButttons.forEach { button in
            button.changeLayer(isSelect: button.tag == 0)
            button.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        }
        
    }
    
    func observeEvent() {
        viewModel.updateBalance = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.balanceLabel.text = "\(self.viewModel.balance)"
            }
        }
        
        viewModel.getBalance()
    }
    
    func setupSubView() {
        depositView.viewModel = viewModel
        
        withdrawView.viewModel = viewModel
        withdrawView.walletVC = self
        //提現完成後
        withdrawView.withdrawClosure = {
            self.viewModel.getBalance()
        }
        
        transferView.viewModel = viewModel
        transferView.walletVC = self
        //內部轉帳完成後
        
        historyView.viewModel = viewModel
    }

    //MARK: - action
    @objc func selectClick(_ btn: UIButton) {
        selectionButttons.forEach { button in
            button.changeLayer(isSelect: button.tag == btn.tag)
        }
        depositView.isHidden = true
        withdrawView.isHidden = true
        transferView.isHidden = true
        historyView.isHidden = true
        switch btn.tag {
        case 0:
            depositView.isHidden = false
        case 1:
            withdrawView.isHidden = false
        case 2:
            transferView.isHidden = false
        default:
            historyView.isHidden = false
        }
    }
    
    
    
    
    
}
