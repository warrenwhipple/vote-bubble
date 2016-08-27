//
//  UIColor+Convenience.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/14/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init?(hexString: String) {
        var int = UInt32()
        guard Scanner(string: hexString).scanHexInt32(&int) else { return nil }
        let (r, g, b) = (int>>16, int>>8 & 0xFF, int & 0xFF)
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }

    func hexString() -> String {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"%06x", rgb)
    }

    static func randomHue() -> UIColor {
        return UIColor(
            hue: CGFloat(arc4random()) / CGFloat(UInt32.max),
            saturation: 1,
            brightness: 0.75,
            alpha: 1
        )
    }

}
