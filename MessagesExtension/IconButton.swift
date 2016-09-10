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
    
    var iconStrokeColor: UIColor = UIColor.white
    var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }

    }

    var iconDiameter: CGFloat = 32
    var dynamicIconDiameter: CGFloat? = nil {
        didSet {
            if let dynamicIconDiameter = dynamicIconDiameter {
                iconDiameter = dynamicIconDiameter * min(bounds.width, bounds.height)
            }
        }
    }

    var iconStrokeWidth: CGFloat = 4
    var dynamicIconStrokeWidth: CGFloat? = nil {
        didSet {
            if let dynamicIconStrokeWidth = dynamicIconStrokeWidth {
                iconStrokeWidth = dynamicIconStrokeWidth * min(bounds.width, bounds.height)
            }
        }
    }

    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    var dynamicCornerRadius: CGFloat? = nil {
        didSet {
            if let dynamicCornerRadius = dynamicCornerRadius {
                cornerRadius = dynamicCornerRadius * min(bounds.width, bounds.height)
            }
        }
    }

    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    var dynamicBorderWidth: CGFloat? = nil {
        didSet {
            if let dynamicBorderWidth = dynamicBorderWidth {
                borderWidth = dynamicBorderWidth * min(bounds.width, bounds.height)
            }
        }
    }

    override func draw(_ rect: CGRect) {
        icon.draw(
            center: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            diameter: iconDiameter,
            rotation: 0,
            strokeWidth: iconStrokeWidth,
            strokeColor: iconStrokeColor
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let dynamicIconDiameter = dynamicIconDiameter {
            iconDiameter = dynamicIconDiameter * min(bounds.width, bounds.height)
        }
        if let dynamicIconStrokeWidth = dynamicIconStrokeWidth {
            iconStrokeWidth = dynamicIconStrokeWidth * min(bounds.width, bounds.height)
        }
        if let dynamicCornerRadius = dynamicCornerRadius {
            cornerRadius = dynamicCornerRadius * min(bounds.width, bounds.height)
        }
        if let dynamicBorderWidth = dynamicBorderWidth {
            borderWidth = dynamicBorderWidth * min(bounds.width, bounds.height)
        }
    }

}
