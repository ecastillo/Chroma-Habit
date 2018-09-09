//
//  Colors.swift
//  HabitApp
//
//  Created by Eric Castillo on 8/20/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import ChameleonFramework

let COLORS = [UIColor.flatRed, UIColor.flatNavyBlue, UIColor.flatMagenta, UIColor.flatSkyBlue, UIColor.flatMint, UIColor.flatBrown, UIColor.flatPink, UIColor.flatCoffee]

extension UIColor {
    struct Theme {
        static var clear: UIColor { return UIColor(hexString: "000000", withAlpha: 0)! }
        static var white: UIColor  { return UIColor(hexString: "FFFFFF")! }
        static var black: UIColor { return UIColor(hexString: "000000")! }
        static var lightGray: UIColor { return UIColor(hexString: "F3F3F3")! }
        static var mediumGray: UIColor { return UIColor(hexString: "E1E1E1")! }
        static var darkGray: UIColor { return UIColor(hexString: "767676")! }
    }
}
