//
//  SplitLayout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 9/1/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct SplitLayout: Layout {

    enum Direction { case horizontal, vertical }

    var firstChild: Layout?
    var secondChild: Layout?
    /// Proportion of the layout devoted to firstChild, 0 to 1
    var split: CGFloat
    var direction: Direction

    init(
        _ firstChild: Layout?,
        _ secondChild: Layout?,
        split: CGFloat,
        direction: Direction) {

        self.firstChild = firstChild
        self.secondChild = secondChild
        self.split = split
        self.direction = direction
    }

    func layout(in rect: CGRect) {
        switch direction {
        case .horizontal:
            firstChild?.layout(in: CGRect(
                x: rect.minX,
                y: rect.minY,
                width: rect.width * split,
                height: rect.height
            ))
            secondChild?.layout(in: CGRect(
                x: rect.minX + rect.width * split,
                y: rect.minY,
                width: rect.width * (1 - split),
                height: rect.height
            ))
        case .vertical:
            firstChild?.layout(in: CGRect(
                x: rect.minX,
                y: rect.minY,
                width: rect.width,
                height: rect.height * split
            ))
            secondChild?.layout(in: CGRect(
                x: rect.minX,
                y: rect.minY + rect.height * split,
                width: rect.width,
                height: rect.height * (1 - split)
            ))
        }
    }

    func firstSize(in size: CGSize) -> CGSize {
        switch direction {
        case .horizontal:
            return CGSize(width: size.width * split, height: size.height)
        case .vertical:
            return CGSize(width: size.width, height: size.height * split)
        }
    }

    func secondSize(in size: CGSize) -> CGSize {
        switch direction {
        case .horizontal:
            return CGSize(width: size.width * (1 - split), height: size.height)
        case .vertical:
            return CGSize(width: size.width, height: size.height * (1 - split))
        }
    }

}
