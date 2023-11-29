//
//  QRCodeManager.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/13.
//

import Foundation
import UIKit

class QRCodeManager {
    //String轉QRcode
    static func generateQRCode(from string: String) -> UIImage? {
        guard let data = string.data(using: .ascii) else {
            return nil
        }
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let outputImage = filter.outputImage {
                let scale = UIScreen.main.scale
                let transformedImage = UIImage(ciImage: outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale)))
                
                return transformedImage
            }
        }
        return nil
    }
    
    static func imageUrlToQrcode(from string: String) -> UIImage? {
        let qrcodeStr = string.replacingOccurrences(of:"data:image/png;base64,",with:"")
        if let data: Data = Data(base64Encoded: qrcodeStr, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
    
}
