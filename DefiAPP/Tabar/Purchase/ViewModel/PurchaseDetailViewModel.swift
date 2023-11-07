//
//  PurchaseDetailViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/3.
//

import Foundation

enum AmountType {
    case min
    case max
    case range
}

class PurchaseDetailViewModel {
    
    let productData: ProductData
    
    var amount: Int = 0 {
        didSet {
            if amount > (productData.maximumAmount ?? 0) {
                self.updateAmount?(.max)
            }else if amount < (productData.minumumAmount ?? 0) {
                self.updateAmount?(.min)
            }else {
                self.updateAmount?(.range)
            }
        }
    }
    
    var updateAmount: ((AmountType) -> ())?
    
    init(productData: ProductData) {
        self.productData = productData
    }
    
    func handleButtonTap(type: Int) {
        if (type == 0 && amount > productData.minumumAmount ?? 0) {
            amount -= 1
        }else if (type == 1 && amount < productData.maximumAmount ?? 0) {
            amount += 1
        }
    }
    
    //預期收到金額
    func expectAmount(monthType: Int) -> String {
        let yearExpect = Double(amount) * (Double(productData.apr ?? 0) / 100)
        let everyMonth = yearExpect / 12.0
        let everySeason = yearExpect / 4.0
        if (monthType == 0) {
            return everyMonth.formatted(.number.precision(.fractionLength(0...3))) + " USDT/月"
        }else {
            return "3個月共 " + everySeason.formatted(.number.precision(.fractionLength(0...3))) + " USDT"
        }
    }
    
}
