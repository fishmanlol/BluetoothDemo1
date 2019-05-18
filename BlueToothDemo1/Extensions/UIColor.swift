//
//  UIColor.swift
//  Fish Music
//
//  Created by Yi Tong on 4/16/19.
//  Copyright © 2019 Yi Tong. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    
    convenience init(r: Int, g: Int, b: Int, alpha: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static var defaultRed: UIColor {
        return UIColor(r: 255, g: 90, b: 95)
    }
    
    static var defaultGray: UIColor {
        return UIColor(r: 118, g: 118, b: 118)
    }
    
    static var themeColor: UIColor {
        return defaultRed
    }
}


