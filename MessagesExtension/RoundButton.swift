//
//  RoundButton.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/22/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

@IBDesignable

class RoundButton: UIButton {

    @IBInspectable var autoAjustsCornerRadius: Bool = true

    override func layoutSubviews() {
        super.layoutSubviews()
        if autoAjustsCornerRadius {
            cornerRadius = min(bounds.width, bounds.height) / 2
        }
    }
}
