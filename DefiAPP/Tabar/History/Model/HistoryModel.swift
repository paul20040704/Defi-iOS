//
//  HistoryModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/16.
//

import Foundation

struct HistoryModel: Codable {
    let data: HistoryData
}

struct HistoryData: Codable {
    let items: [ItemsData]
}

struct ItemsData: Codable {
    let id: String?
    let amount: Int?
    let autoRenewEnabled: Bool
    let beginDate: String?
    let endDate: String?
    let productId: String?
    let userId: String?
    let product: ProductData
    let statuses: [ItemStatus]
}
    
struct ItemStatus: Codable {
    let createdBy: String?
    let createdAt: String?
    let id: String
    let reason: String?
    let status: String?
}
