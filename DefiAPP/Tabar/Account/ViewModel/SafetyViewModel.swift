//
//  SafetyViewModel.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/10.
//

import Foundation

class SafetyViewModel {
    
    var updateSwitch: ((Bool) ->())?
    
    //判斷是否開啟FaceId
    func getFaceID() {
        let isFaceIdOpen = UD.bool(forKey: UserDefaultsKey.faceID.rawValue)
        self.updateSwitch?(isFaceIdOpen)
    }
    
    //開關FaceId
    func switchFaceId() {
        let isFaceIdOpen = UD.bool(forKey: UserDefaultsKey.faceID.rawValue)
        UD.setValue(!isFaceIdOpen, forKey: UserDefaultsKey.faceID.rawValue)
    }
    
    
    
}
