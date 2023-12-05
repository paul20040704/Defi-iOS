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


struct SwapModel: Codable {
    let data: [SwapData]
}

struct SwapData: Codable {
    let swapId: Int?
    let fromCryptocurrencySymbol: String?
    let fromCryptocurrencyDecimal: Int?
    let fromCryptocurrencyBalance: Double?
    let fromCryptocurrencyMinAmount: Double?
    let fromCryptocurrencyMaxAmount: Double?
    let toCryptocurrencySymbol: String?
    let toCryptocurrencyDecimal: Int?
    let toCryptocurrencyBalance: Double?
    let toCryptocurrencyMinAmount: Double?
    let toCryptocurrencyMaxAmount: Double?
    let rate: Double?
    let systemFeePercentage: Double?
}

struct SwapQuotationModel: Codable {
    let data: SwapQuotationData
}

struct SwapQuotationData: Codable {
    var swapId: Int? = nil
    var swapQuotationId: String? = nil
    var fromCryptocurrencySymbol: String? = nil
    var fromCryptocurrencyAmount: Double? = nil
    var toCryptocurrencySymbol: String? = nil
    var toCryptocurrencyAmount: Double? = nil
    var rate: Double? = nil
    var systemFeePercentage: Double? = nil
    var systemFee: Double? = nil
}

