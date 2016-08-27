//
//  SplitLayout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct SplitLayout: Layout {

    enum Direction { case horizontal, vertical }

    var direction: Direction
    var splitPercent: CGFloat
    var childA, childB: Layout

    mutating func layout(in rect: CGRect) {
        switch direction {
        case .horizontal:
            childA.layout(in: CGRect(x: rect.minX,
                                     y: rect.minY,
                                     width: rect.width * splitPercent,
                                     height: rect.height))
            childB.layout(in: CGRect(x: rect.minX + rect.width * splitPercent,
                                     y: rect.minY,
                                     width: rect.width * (1 - splitPercent),
                                     height: rect.height))
        case .vertical:
            childA.layout(in: CGRect(x: rect.minX,
                                     y: rect.minY,
                                     width: rect.width,
                                     height: rect.height * splitPercent))
            childB.layout(in: CGRect(x: rect.minX,
                                     y: rect.minY + rect.height * splitPercent,
                                     width: rect.width,
                                     height: rect.height * (1 - splitPercent)))
        }
    }

}
