//
//  InvestVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import UIKit
import PKHUD

class HistoryVC: UIViewController {

    @IBOutlet weak var managementButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var nextButton: CustomNextButton!
    
    @IBOutlet weak var noneView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUI()
        initTableView()
        observeEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        viewModel.getHistory()
        HUD.show(.systemActivity, onView: self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setUI() {
        managementButton.changeLayer(isSelect: true)
        managementButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextClick), for: .touchUpInside)
    }
    
    func initTableView() {
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func observeEvent() {
        viewModel.reloadTableView = { [weak self] in 
            guard let self else { return }
            DispatchQueue.main.async {
                HUD.hide()
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - Action
    @objc func selectClick(_ btn: UIButton) {
        viewModel.selection = btn.tag
        if btn.tag == 0 {
            managementButton.changeLayer(isSelect: true)
            historyButton.changeLayer(isSelect: false)
        }else {
            managementButton.changeLayer(isSelect: false)
            historyButton.changeLayer(isSelect: true)
        }
        tableView.reloadData()
    }

    @objc func nextClick() {
        self.tabBarController?.selectedIndex = 0
    }
    
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.selection == 0 {
            noneView.isHidden = viewModel.historyDatas.count > 0
            return viewModel.historyDatas.count
        }else {
            noneView.isHidden = viewModel.gainDatas.count > 0
            return viewModel.gainDatas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.selection == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
            cell.setup(productData: viewModel.historyDatas[indexPath.row])
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemData = viewModel.historyDatas[indexPath.row]
        let historyDetailVC = UIStoryboard(name: "History", bundle: nil).instantiateViewController(withIdentifier: "HistoryDetailVC") as! HistoryDetailVC
        let viewModel = HistoryDetailViewModel(itemsData: itemData)
        historyDetailVC.viewModel = viewModel
        self.navigationController?.show(historyDetailVC, sender: nil)
    }
    
    
}
