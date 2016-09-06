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

    var hsba: (CGFloat, CGFloat, CGFloat, CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue, saturation, brightness, alpha)
    }

    var hue:        CGFloat { return hsba.0 }
    var saturation: CGFloat { return hsba.1 }
    var brightness: CGFloat { return hsba.2 }
    var alpha:      CGFloat { return hsba.3 }

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

    static func furthest(from colors: [UIColor]) -> UIColor {
        if colors.isEmpty {
            return UIColor(hue: 0, saturation: 1, brightness: 1, alpha: 1)
        }
        let sortedHSBA = colors
            .map { color in color.hsba }
            .sorted { (a,b) in a.0 < b.0 }
        // Check wraparound hue first
        var bestLeft = sortedHSBA.last!
        var bestRight = sortedHSBA.first!
        var bestHueGap = bestLeft.0 - (bestRight.0 + 1)
        for i in 0 ..< sortedHSBA.count - 1 {
            let left = sortedHSBA[i]
            let right = sortedHSBA[i+1]
            let hueGap = right.0 - left.0
            if hueGap > bestHueGap {
                bestLeft = left
                bestRight = right
                bestHueGap = hueGap
            }
        }
        var hue = bestLeft.0 + bestHueGap / 2
        if hue > 1 {
            hue -= 1
        }
        let saturation = (bestLeft.1 + bestRight.1) / 2
        let brightness = (bestLeft.2 + bestRight.2) / 2
        let alpha      = (bestLeft.3 + bestRight.3) / 2
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
}
