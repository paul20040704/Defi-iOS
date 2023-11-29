//
//  WalletHistoryModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/28.
//

import Foundation


struct LedgerModel: Codable {
    let data: LedgerItem
}

struct LedgerItem: Codable {
    let items: [LedgerData]
}

struct LedgerData: Codable {
    let id: String?
    let account: String?
    let amount: Double?
    let status: String?
    let asset: String?
    let chain: String?
    let purpose: String?
    let referenceData: String?
    let userId: String?
    let referenceUserId: String?
    let createdAt: String?
    let createdBy: String?
}
