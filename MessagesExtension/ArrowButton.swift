//
//  ArrowButton.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/22/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

@IBDesignable

class ArrowButton: UIButton {

    @IBInspectable var diameter: CGFloat = 32
    @IBInspectable var rotation: CGFloat = 0
    @IBInspectable var strokeWidth: CGFloat = 4
    @IBInspectable var strokeColor: UIColor = UIColor.white

    override func draw(_ rect: CGRect) {
        DrawIcon.arrow(
            center: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            diameter: diameter,
            rotation: rotation,
            strokeWidth: strokeWidth,
            strokeColor: strokeColor
        )
    }
}
