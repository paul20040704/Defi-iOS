//
//  ApplyPurchaseModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/15.
//

import Foundation


struct BalanceModel: Codable {
    let data: [BalanceData]
}

struct BalanceData: Codable {
    let userId: String?
    let chain: String?
    let asset: String?
    let account: String?
    let balance: Int?
}

struct ContractModel: Codable {
    let data: ContractData
}

struct ContractData: Codable {
    let id: String?
    let amount: Int?
    let autoRenewEnabled: Bool
    let beginDate: String?
    let endDate: String?
    let productId: String?
    let userId: String
}
