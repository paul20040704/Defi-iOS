//
//  HistoryViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/16.
//

import Foundation

class HistoryViewModel {
    //申購項目
    var historyDatas: [ItemsData] = [ItemsData]() {
        didSet {
            self.reloadTableView?()
        }
    }
    //收益紀錄
    var gainDatas = Array<Any>()
    
    var selection = 0 // 0申購項目 1收益紀錄
    
    var reloadTableView: VoidClosure?
    
    
    //取得申購紀錄
    func getHistory() {
        NS.fetchData(urlStr: "v1/Contract/all/10/1", method: "GET", isToken: true) { (result: Result<HistoryModel, APIError>) in
            switch result {
            case .success(let fetchData):
                self.historyDatas = fetchData.data.items
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}
