//
//  NibOwnerLoadableEx.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/10.
//

import Foundation
import UIKit

protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib {get}
}

extension NibOwnerLoadable {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

extension NibOwnerLoadable where Self: UIView {
    func loadNibContent() {
            guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
                let contentView = views.first else {
                    fatalError("Fail to load \(self) nib content")
            }
            self.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
}
