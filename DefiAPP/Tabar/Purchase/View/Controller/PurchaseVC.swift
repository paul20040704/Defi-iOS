//
//  PurchaseVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/2.
//

import UIKit

class PurchaseVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var purchaseViewModel = PurachaseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        observeEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func initTableView() {
        let nib = UINib(nibName: "WalletNoticeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WalletNoticeCell")
        let nib1 = UINib(nibName: "CurrencyCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "CurrencyCell")
        let nib2 = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "ProductCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func observeEvent() {
        purchaseViewModel.updateProductView = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        purchaseViewModel.getProduct()
        purchaseViewModel.getMemberInfo()
    }


}

extension PurchaseVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseViewModel.productModel.data.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let walletNoticeCell = tableView.dequeueReusableCell(withIdentifier: "WalletNoticeCell", for: indexPath)
        let currencyCell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        let productCell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        switch indexPath.row {
        case 0:
            return walletNoticeCell
        case 1:
            return currencyCell
        default:
            let product = purchaseViewModel.productModel.data[indexPath.row - 2]
            productCell.setup(productData: product)
            return productCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        default:
            let product = purchaseViewModel.productModel.data[indexPath.row - 2]
            let purchaseDetailVC = UIStoryboard(name: "Purchase", bundle: nil).instantiateViewController(withIdentifier: "PurchaseDetailVC") as! PurchaseDetailVC
            let viewModel = PurchaseDetailViewModel(productData: product)
            purchaseDetailVC.viewModel = viewModel
            self.navigationController?.show(purchaseDetailVC, sender: nil)
        }
    }
}
