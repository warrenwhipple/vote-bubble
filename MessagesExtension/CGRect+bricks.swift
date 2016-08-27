//
//  CGRect+bricks.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

extension CGRect {

    func bricks(count: Int) -> [CGRect] {
        guard count > 0 else { return [] }
        var rects: [CGRect] = []
        rects.reserveCapacity(count)
        var columnCount = 1
        var rowCount = 1
        while columnCount * rowCount < count {
            if columnCount == rowCount {
                columnCount += 1
            } else {
                rowCount += 1
            }
        }
        let emptyCellCount = columnCount * rowCount - count
        let rowHeight = size.height / CGFloat(rowCount)
        for rowIndex in 0 ..< rowCount {
            let thisRowColumnCount: Int
            if rowIndex < emptyCellCount {
                thisRowColumnCount = columnCount - 1
            } else {
                thisRowColumnCount = columnCount
            }
            let thisRowColumnWidth = size.width / CGFloat(thisRowColumnCount)
            for columnIndex in 0 ..< thisRowColumnCount {
                rects.append(
                    CGRect(
                        x: origin.x + CGFloat(columnIndex) * thisRowColumnWidth,
                        y: origin.y + CGFloat(rowIndex) * rowHeight,
                        width: thisRowColumnWidth,
                        height: rowHeight
                    )
                )
            }
        }
        return rects
    }
    
}
