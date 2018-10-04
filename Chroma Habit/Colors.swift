//
//  Colors.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/20/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import DynamicColor
import UIKit

//let COLORS = [UIColor.flatRed,
//              UIColor.flatNavyBlue,
//              UIColor.flatMagenta,
//              UIColor.flatSkyBlue,
//              UIColor.flatMint,
//              UIColor.flatBrown,
//              UIColor.flatPink,
//              UIColor.flatCoffee,
//              UIColor.flatMaroon,
//              UIColor.flatLime,
//              UIColor.flatYellowDark,
//              UIColor.flatGrayDark,
//              UIColor.flatForestGreen,
//              UIColor.flatOrange,
//              UIColor.flatPowderBlueDark]

let COLORS = [UIColor(hexString: "DF342E"),
              UIColor(hexString: "28384B"),
              UIColor(hexString: "8840A7"),
              UIColor(hexString: "2B84D2"),
              UIColor(hexString: "1FB18A"),
              UIColor(hexString: "4B3527"),
              UIColor(hexString: "EE62B6"),
              UIColor(hexString: "91735E"),
              UIColor(hexString: "652220"),
              UIColor(hexString: "96BD2D"),
              UIColor(hexString: "FD9809"),
              UIColor(hexString: "6C797A"),
              UIColor(hexString: "284D32"),
              UIColor(hexString: "DE6A1B"),
              UIColor(hexString: "889ACB")]

extension UIColor {
    struct Theme {
        //static var clear: UIColor { return UIColor(hexString: "000000", withAlpha: 0)! }
//        static var white: UIColor  { return UIColor(hexString: "FFFFFF")! }
//        static var black: UIColor { return UIColor(hexString: "000000")! }
//        static var lightGray: UIColor { return UIColor(hexString: "F3F3F3")! }
//        static var mediumGray: UIColor { return UIColor(hexString: "E1E1E1")! }
//        static var darkGray: UIColor { return UIColor(hexString: "767676")! }
        
        static var clear: UIColor { return UIColor(hexString: "000000").withAlphaComponent(0) }
        static var white: UIColor { return UIColor(hexString: "FFFFFF") }
        static var black: UIColor { return UIColor(hexString: "000000") }
        static var lightGray: UIColor { return UIColor(hexString: "F3F3F3") }
        static var mediumGray: UIColor { return UIColor(hexString: "E1E1E1") }
        static var darkGray: UIColor { return UIColor(hexString: "767676") }
    }
}


extension UIColor {
    var hexString: String {
        let colorRef = cgColor.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha
        
        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        
        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a)))
        }
        
        return color
    }
}
