//
//  PurchaseModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/2.
//

import Foundation

struct ProductModel: Codable {
    let data: [ProductData]
}

struct ProductData: Codable {
    let id: String?
    let apr: Int?
    let asset: String?
    let chain: String?
    let lDs: Int?
    let maximumAmount: Int?
    let minumumAmount: Int?
    let period: Period
    let subscriptionEndDate: String?
    let subscriptionStartDate: String?
    let hasBegun: Bool
    let hasEnded: Bool
    let isPurchaseable: Bool
    let isExpired: Bool
    
}

struct Period: Codable {
    let length: Int?
    let unit: String?
}


