//
//  HistoryView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/21.
//

import UIKit
import PKHUD

class HistoryView: UIView, NibOwnerLoadable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noReocrdView: UIView!
    
    var dropMenu = DropDownView()
    
    var viewModel: WalletViewModel? {
        didSet {
            self.observeEvent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        commonInit()
        initTableView()
    }
    
    func loadXib() {
        loadNibContent()
    }
    
    func commonInit() {
        dropMenu = DropDownView(frame: CGRect(x: ScreenWidth - 220, y: 10, width: 200, height: 35))
        dropMenu.rowHeight = 35
        dropMenu.datas = TransactionType.allCases.map { "\($0)" }
        dropMenu.openMenuClosure = { isOpen in
            self.menuBGView.isHidden = !isOpen
        }
        
        dropMenu.cellClickClosure = { [weak self] type in
            guard let self else { return }
            HUD.show(.systemActivity, onView: self)
            self.viewModel?.getLedger(from: TransactionType.getEnglishDescription(fromChinese: type))
        }
        
        self.addSubview(menuBGView)
        self.addSubview(dropMenu)
    }
    
    func initTableView() {
        let nib = UINib(nibName: "WalletHistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WalletHistoryCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func observeEvent() {
        viewModel?.ledgerClosure = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                self.tableView.reloadData()
            }
        }
        
        HUD.show(.systemActivity, onView: self)
        viewModel?.getLedger(from: TransactionType.提領.rawValue)
    }
    
    @objc func closeMenu() {
        menuBGView.isHidden = true
        dropMenu.closeMenu()
    }
//MARK: -Lazy
    lazy var menuBGView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .clear
        view.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        view.addGestureRecognizer(tap)
        return view
    }()
    
}

extension HistoryView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.noReocrdView.isHidden = viewModel?.ledgerItems.count ?? 0 > 0
        return viewModel?.ledgerItems.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletHistoryCell", for: indexPath) as! WalletHistoryCell
        cell.setup(data: viewModel?.ledgerItems[indexPath.row])
        return cell
    }
    
    
}


enum TransactionType: String, CaseIterable {
    case 提領 = "Withdrawal"
    case 儲值 = "Deposit"
    case 取消提領 = "CancelWithdraw"
    case 開立交易合約 = "OpenContract"
    case 關閉交易合約 = "CloseContract"
    case 交易獲利 = "EarnedProfit"
    case 違約金 = "LiquidatedDamage"
    case 內部充值 = "UserTransferIn"
    case 內部轉帳 = "UserTransferOut"
    case 推薦獎勵 = "ReferralReward"
    case 團體獎勵 = "TeamReward"
    
    //通過中文描述獲取英文描述
    static func getEnglishDescription(fromChinese description: String) -> String {
        return allCases.first { "\($0)" == description }?.rawValue ?? "找不到英文描述"
    }
}


