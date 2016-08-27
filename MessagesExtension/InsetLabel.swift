//
//  InsetLabel.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/19/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//
// From Nikolai Ruhe
// http://stackoverflow.com/questions/21167226/#21267507

import UIKit

class InsetLabel: UILabel {

    var textInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override func textRect(
        forBounds bounds: CGRect,
        limitedToNumberOfLines numberOfLines: Int
        ) -> CGRect {

        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(
            forBounds: insetRect,
            limitedToNumberOfLines: numberOfLines
        )
        let invertedInsets = UIEdgeInsets(
            top: -textInsets.top,
            left: -textInsets.left,
            bottom: -textInsets.bottom,
            right: -textInsets.right
        )
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }

}
