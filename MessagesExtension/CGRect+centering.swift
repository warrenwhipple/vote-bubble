//
//  CGRect+centering.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/19/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

extension CGRect {

    var center: CGPoint {
        return CGPoint(
            x: (origin.x + size.width) / 2,
            y: (origin.y + size.height) / 2
        )
    }

    func centeredRect(ofSize: CGSize) -> CGRect {
        return CGRect(
            x: (origin.x + size.width - ofSize.width) / 2,
            y: (origin.y + size.height - ofSize.height) / 2,
            width: ofSize.width,
            height: ofSize.height
        )
    }

    func topSlice(of fraction: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x,
            y: origin.y,
            width: size.width,
            height: size.height * fraction
        )
    }

    func bottomSlice(of fraction: CGFloat) -> CGRect {
        return CGRect(
            x: origin.x,
            y: origin.y + size.height * (1 - fraction),
            width: size.width,
            height: size.height * fraction
        )
    }
    
}
