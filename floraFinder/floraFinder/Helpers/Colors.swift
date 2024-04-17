//
//  Colors.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import UIKit

public extension UIColor {
    /// (#111111) Черный  текст
    static var primaryText: UIColor { UIColor(hex: "111111") }
    
    static var mainBackGround: UIColor { UIColor(hex: "c7f2d8") }
    
    static var secondaryBackGround: UIColor { UIColor(hex: "60D6A7") }
    
    static var cellBackGround: UIColor { UIColor(hex: "72a892") }
    
    static var border: UIColor { UIColor(hex: "faf7f7") }
    
    static var shadow: UIColor { UIColor(hex: "ede8e8") }
}

public extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hex = hex
        
        
        let scanner = Scanner(string: hex)
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        self.init(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: alpha
        )
    }
}
