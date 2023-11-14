//
//  GaModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/13.
//

import Foundation

struct GaModel: Codable {
    let data: GaData
}

struct GaData: Codable {
    var qrCodeSetupImageUrl: String?
    var manualEntryKey: String?
}
