//
//  CGRect+bricks.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

extension CGRect {

    static func bricks(containerWidth: CGFloat, count: Int) -> (CGSize, [CGRect]) {
        assert(count >= 0)
        var rects: [CGRect] = []
        rects.reserveCapacity(count)
        let rowCount = Int(floor(sqrt(Float(count))))
        let columnCount = (count + rowCount - 1) / rowCount
        let longRowCount = count % rowCount
        let shortRowCount = longRowCount == 0 ? 0 : rowCount - longRowCount
        let rowHeight = containerWidth / CGFloat(columnCount)
        for i in 0 ..< rowCount {
            let y = CGFloat(i) * rowHeight
            let localRowColumnCount = i < shortRowCount ? columnCount - 1 : columnCount
            let columnWidth = containerWidth / CGFloat(localRowColumnCount)
            for j in 0 ..< localRowColumnCount {
                rects.append(
                    CGRect(
                        x: CGFloat(j) * columnWidth,
                        y: y,
                        width: columnWidth,
                        height: rowHeight
                    )
                )
            }
        }
        let containerSize = CGSize(
            width: containerWidth,
            height: CGFloat(rowCount) * rowHeight
        )
        return (containerSize, rects)
    }

    static func aspectRatioForBrickCount(_ count: Int) -> CGFloat {
        let rowCount = Int(floor(sqrt(Float(count))))
        let columnCount = (count + rowCount - 1) / rowCount
        return CGFloat(columnCount) / CGFloat(rowCount)
    }
}
