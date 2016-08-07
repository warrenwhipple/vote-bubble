//
//  PlusIconView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/22/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

@IBDesignable

class PlusIconView: UIView {

    @IBInspectable var strokeColor: UIColor = UIColor.white
    @IBInspectable var strokeWidth: CGFloat = 4

    override func draw(_ rect: CGRect) {
        DrawIcon.plus(
            center: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            diameter: min(bounds.width, bounds.height),
            strokeWidth: strokeWidth,
            strokeColor: strokeColor
        )
    }
}
