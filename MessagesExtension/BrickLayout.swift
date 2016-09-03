//
//  BrickLayout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct BrickLayout: Layout {

    var children: [Layout?]

    mutating func layout(in rect: CGRect) {
        guard !children.isEmpty else { return }
        var columnCount = 1
        var rowCount = 1
        while columnCount * rowCount < children.count {
            if columnCount == rowCount {
                columnCount += 1
            } else {
                rowCount += 1
            }
        }
        let emptyCellCount = columnCount * rowCount - children.count
        let rowHeight = rect.height / CGFloat(rowCount)
        var childIndex = 0
        for rowIndex in 0 ..< rowCount {
            let thisRowColumnCount: Int
            if rowIndex < emptyCellCount {
                thisRowColumnCount = columnCount - 1
            } else {
                thisRowColumnCount = columnCount
            }
            let thisRowColumnWidth = rect.width / CGFloat(thisRowColumnCount)
            for columnIndex in 0 ..< thisRowColumnCount {
                let brickRect = CGRect(
                    x: rect.minX + CGFloat(columnIndex) * thisRowColumnWidth,
                    y: rect.minY + CGFloat(rowIndex) * rowHeight,
                    width: thisRowColumnWidth,
                    height: rowHeight
                )
                children[childIndex]?.layout(in: brickRect)
                childIndex += 1
            }
        }
    }

    func smallestBrick(in size: CGSize) -> CGSize {
        guard !children.isEmpty else { return size }
        var columnCount = 1
        var rowCount = 1
        while columnCount * rowCount < children.count {
            if columnCount == rowCount {
                columnCount += 1
            } else {
                rowCount += 1
            }
        }
        return CGSize(width: size.width / CGFloat(columnCount),
                      height: size.height / CGFloat(rowCount))
    }
}
