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
    
    //取得產品
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
    
    func getMemberInfo() {
        NS.fetchData(urlStr: "v1/User", method: "GET", isToken: true) { (result: Result<MemberModel, APIError>)  in
            switch result {
            case .success(let fetchData):
                UserDefaultsManager.shared.memberInfo = fetchData.data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
