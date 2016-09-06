//
//  IconButton.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class IconButton: UIButton {

    var icon: Icon = .none
    var diameterPercent: CGFloat = 0.75
    var iconStrokeWidth: CGFloat = 1
    var iconStrokeColor: UIColor = UIColor.white

    override func draw(_ rect: CGRect) {
        icon.draw(
            center: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            diameter: diameterPercent * min(bounds.width, bounds.height),
            rotation: 0,
            strokeWidth: iconStrokeWidth,
            strokeColor: iconStrokeColor
        )
    }

}
