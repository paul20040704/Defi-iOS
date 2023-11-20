//
//  HistoryDetailModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/17.
//

import Foundation

struct DamageModel: Codable {
    let data: Double?
    let timestamp: Int?
}

struct RenewModel: Codable {
    let data: Bool
    let timestamp: Int?
}

struct RevokeModel: Codable {
    let data: Bool
    let timestamp: Int?
}
