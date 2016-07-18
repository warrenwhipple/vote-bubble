//
//  BrickView.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/17/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BrickView: UIView {

    private(set) var aspectRatioConstraint: NSLayoutConstraint?

    override func layoutSubviews() {
        super.layoutSubviews()
        let (_, rects) = CGRect.bricks(
            containerWidth: bounds.width,
            count: subviews.count
        )
        for (subview, rect) in zip(subviews, rects) {
            subview.frame = rect
        }
    }

    func updateAspectRatioConstraint() {
        if aspectRatioConstraint == nil {
            for constraint in constraints {
                if     constraint.firstItem as? NSObject == self
                    && constraint.firstAttribute == .width
                    && constraint.relation == .equal
                    && constraint.secondItem as? NSObject == self
                    && constraint.secondAttribute == .height
                    && constraint.constant == 0 {
                    aspectRatioConstraint = constraint
                    break
                }
            }
        }
        let aspectRatio = CGRect.aspectRatioForBrickCount(subviews.count)
        guard aspectRatioConstraint?.multiplier != aspectRatio else { return }
        if let aspectRatioConstraint = aspectRatioConstraint {
            removeConstraint(aspectRatioConstraint)
        }
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .height,
            multiplier: aspectRatio,
            constant: 0
        )
        addConstraint(constraint)
        aspectRatioConstraint = constraint
    }
}
