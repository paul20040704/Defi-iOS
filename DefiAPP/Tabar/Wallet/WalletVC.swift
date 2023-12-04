//
//  WalletVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/6.
//

import UIKit

class WalletVC: UIViewController {

    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var lockLabel: UILabel!
    @IBOutlet var selectionButttons: [UIButton]!
    
    @IBOutlet weak var depositView: DepositView!
    @IBOutlet weak var withdrawView: WithdrawView!
    @IBOutlet weak var transferView: TransferView!
    @IBOutlet weak var historyView: HistoryView!
    @IBOutlet weak var swapView: SwapView!
    
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
        hideButton.addTarget(self, action: #selector(hideBalanceClick), for: .touchUpInside)
        selectionButttons.forEach { button in
            button.changeLayer(isSelect: button.tag == 0)
            button.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        }
        
    }
    
    func observeEvent() {
        viewModel.updateBalance = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.hideButton.setImage(UIImage(named: self.viewModel.isHideBalance ? "show" : "hide"), for: .normal)
                self.balanceLabel.text = self.viewModel.isHideBalance ? "\((self.viewModel.balanceData?.balance ?? 0) + (self.viewModel.balanceData?.lockedBalance ?? 0))" : "***"
                self.availableLabel.text = self.viewModel.isHideBalance ? "可用\(self.viewModel.balanceData?.balance ?? 0)" : "可用***"
                self.lockLabel.text = self.viewModel.isHideBalance ? "鎖倉 \(self.viewModel.balanceData?.lockedBalance ?? 0)" : "鎖倉***"
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
        swapView.isHidden = true
        transferView.isHidden = true
        historyView.isHidden = true
        switch btn.tag {
        case 0:
            depositView.isHidden = false
        case 1:
            withdrawView.isHidden = false
        case 2:
            swapView.isHidden = false
        case 3:
            transferView.isHidden = false
        default:
            historyView.isHidden = false
        }
    }
    
    @objc func hideBalanceClick() {
        viewModel.changeHideBalance()
    }
    
    
    
}
