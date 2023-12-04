//
//  SwapView.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/30.
//

import UIKit

class SwapView: UIView, NibOwnerLoadable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib() {
        loadNibContent()
    }

}
