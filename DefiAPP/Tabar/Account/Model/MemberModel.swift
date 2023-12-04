//
//  MemberModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/8.
//

import Foundation

struct MemberModel: Codable {
    let data: MemberInfo
}

struct MemberInfo: Codable {
    var createdBy: String? = nil
    var createdAt: String? = nil
    var updatedBy: String? = nil
    var updatedAt: String? = nil
    var id: String? = nil
    var email: String? = nil
    var nickname: String? = nil
    var isWalletConnect: Bool = false
    var isActivated: Bool = false
    var isEmailVerified: Bool = false
    var isAdmin: Bool = false
    var isGaEnabled: Bool = false
    var isSuspended: Bool = false
    var refererId: String? = nil
    var wallets: [WalletData]? = []
}

struct WalletData: Codable {
    let symbol: String?
    let addresses: [AddressData]
    let balance: Double?
    let lockedBalance: Double
}

struct AddressData: Codable {
    let `protocol`: String?
    let chain: String?
    let asset: String?
    let address: String?
}
