//
//  UIFont.swift
//  Fish Music
//
//  Created by Yi Tong on 4/16/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static func pingfang(bold: Bold = .regular, size: CGFloat) -> UIFont {
        
        let name: String
        
        switch bold {
        case .thin:
            name = "PingFangSC-Thin"
        case .regular:
            name = "PingFangSC-Regular"
        case .bold:
            name = "PingFangSC-Medium"
        }
        
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    enum Bold {
        case regular, bold, thin
    }
}
