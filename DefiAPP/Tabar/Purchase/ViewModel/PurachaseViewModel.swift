//
//  PurachaseViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/2.
//

import Foundation

class PurachaseViewModel {
    
    var productModel: ProductModel = ProductModel(data: []) {
        didSet {
            self.updateProductView?()
        }
    }
    
    var updateProductView: VoidClosure?
    
    func getProduct() {
        NS.fetchData(urlStr: "v1/Product/all/purchaseable", method: "GET", isToken: false) { (result: Result<ProductModel, APIError>) in
            switch result{
            case .success(let fetchData):
                self.productModel = fetchData
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
}
