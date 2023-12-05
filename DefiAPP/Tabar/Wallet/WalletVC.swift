//
//  WalletVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/6.
//

import UIKit

class WalletVC: UIViewController {

    @IBOutlet weak var hideButton: UIButton!
    
    @IBOutlet var selectionButttons: [UIButton]!
    
    @IBOutlet weak var collectionView: UICollectionView!
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
        addNotification()
        setupSubView()
        collectionView.delegate = self
        collectionView.dataSource = self
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
                self.collectionView.reloadData()
            }
        }
        viewModel.getBalance()
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getBalance), name: .walletNotification, object: nil)
    }
    
    func setupSubView() {
        self.viewModel.walletVC = self
        
        depositView.viewModel = viewModel
        
        withdrawView.viewModel = viewModel
        
        swapView.viewModel = viewModel
        
        transferView.viewModel = viewModel
        
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
    
    @objc func getBalance() {
        self.viewModel.getBalance()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension WalletVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.balanceDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCollectionCell", for: indexPath) as! WalletCollectionCell
        cell.setup(data: viewModel.balanceDatas[indexPath.row], isHide: viewModel.isHideBalance)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let cellWidth = collectionWidth - 50
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}
