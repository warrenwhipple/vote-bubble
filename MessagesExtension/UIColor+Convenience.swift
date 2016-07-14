//
//  UIColor+Convenience.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/14/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

extension UIColor {
    static func randomHue() -> UIColor {
        return UIColor(
            hue: CGFloat(arc4random()) / CGFloat(UInt32.max),
            saturation: 1,
            brightness: 0.5,
            alpha: 1
        )
    }
}
