//
//  LoginModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import Foundation

struct LoginData: Codable {
    let data: String?
    let statusCode: Int?
    let success: Bool
    let message: String?
    let timestamp: Int?
}

