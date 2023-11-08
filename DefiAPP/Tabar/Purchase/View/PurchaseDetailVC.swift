//
//  PurchaseDetailVC.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/3.
//

import UIKit

class PurchaseDetailVC: UIViewController {
    @IBOutlet weak var overScrollView: UIScrollView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    
    @IBOutlet weak var detailView: DetailView!
    
    @IBOutlet weak var overViewButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var seasonAprLabel: UILabel!
    @IBOutlet weak var aprLabel: UILabel!
    @IBOutlet weak var contractLabel: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var reduceButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var expectLabel: UILabel!
    @IBOutlet weak var seasonExpectLabel: UILabel!
    
    @IBOutlet weak var nextButton: CustomNextButton!
    
    var viewModel: PurchaseDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.isNavigationBarHidden = false
        setUI()
        observeEvent()
    }
    
    func setUI() {
        overViewButton.changeLayer(isSelect: true)
        overViewButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        detailButton.addTarget(self, action: #selector(selectClick(_:)), for: .touchUpInside)
        
        reduceButton.addTarget(self, action: #selector(amountButtonClick(_:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(amountButtonClick(_:)), for: .touchUpInside)
        amountTextField.addTarget(self, action: #selector(observeAmount), for: .editingChanged)
        amountTextField.keyboardType = .numberPad
        
        self.seasonAprLabel.text = "\(Double(viewModel?.productData.apr ?? 0) / 4)%"
        self.aprLabel.text = "\(viewModel?.productData.apr ?? 0)%"
        self.contractLabel.text = "\(viewModel?.productData.period.length ?? 0)個月"
        
        detailView.productData = viewModel?.productData
    }
    
    func observeEvent() {
        viewModel?.updateAmount = { [weak self] amountType in
            guard let self else { return }
            self.amountTextField.text = "\(self.viewModel?.amount ?? 0)"
            self.expectLabel.text = self.viewModel?.expectAmount(monthType: 0) 
            self.seasonExpectLabel.text = self.viewModel?.expectAmount(monthType: 1)
            switch amountType {
            case .min:
                self.amountLabel.text = "低於最小申購金額"
                self.amountLabel.textColor = .red
                self.nextButton.updateButton(isNext: false)
            case .max:
                self.amountLabel.text = "高於最大申購金額"
                self.amountLabel.textColor = .red
                self.nextButton.updateButton(isNext: false)
            case .range:
                self.amountLabel.text = "\(self.viewModel?.amount ?? 0) USDT"
                self.amountLabel.textColor = UIColor(hex: "#434C48")
                self.nextButton.updateButton(isNext: true)
            }
        }
        
        viewModel?.amount = viewModel?.productData.minumumAmount ?? 0
    }

    @objc func selectClick(_ btn: UIButton) {
        if btn.tag == 0 {
            overViewButton.changeLayer(isSelect: true)
            detailButton.changeLayer(isSelect: false)
            overScrollView.isHidden = false
            detailScrollView.isHidden = true
        }else {
            overViewButton.changeLayer(isSelect: false)
            detailButton.changeLayer(isSelect: true)
            overScrollView.isHidden = true
            detailScrollView.isHidden = false
        }
    }
    
    @objc func amountButtonClick(_ btn: UIButton) {
        viewModel?.handleButtonTap(type: btn.tag)
    }
    
    @objc func observeAmount() {
        viewModel?.amount = Int(amountTextField.text ?? "0") ?? 0
    }
    

}
