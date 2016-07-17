//
//  BrickView.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/17/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BrickView: UIView {

    var aspectRatioConstraint: NSLayoutConstraint?

    override func layoutSubviews() {
    }

    func arrangeSubviewsAsBricks(containerWidth: CGFloat) -> CGSize {
        let (contaierSize, rects) = CGRect.bricks(
            containerWidth: containerWidth,
            count: subviews.count
        )
        for (subview, rect) in zip(subviews, rects) {
            subview.frame = rect
        }
        return contaierSize
    }
}
