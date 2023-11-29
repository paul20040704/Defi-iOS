//
//  WalletModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/21.
//

import Foundation

struct AssetType: Codable {
    let data: AssetTypeData
}

struct AssetTypeData: Codable {
    let withdrawFee: Double?
    let minimumWithdraw: Double?
    let maximumWithdraw: Double?
    let explorerUrl: String?
}


struct WithdrawModel: Codable {
    let data: WithdrawData
}

struct WithdrawData: Codable {
    var id: String? = nil
    var amount: Double? = nil
    var asset: String? = nil
    var chain: String? = nil
    var cryptoTransactionId: String? = nil
    var to: String? = nil
    var userId: String? = nil
    var transaction: String? = nil
}



