//
//  DoubleEx.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/22.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
    
    func countByRate(rate: Double, decimal: Int) -> Double {
        let multiplier = pow(10.0, Double(decimal))
        return (self * multiplier * rate).rounded() / multiplier
    }
}
