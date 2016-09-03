//
//  StackLayout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct StackLayout: Layout {

    enum Direction { case horizontal, vertical }

    var children: [Layout]
    var weights: [CGFloat]?
    var direction: Direction

    mutating func layout(in rect: CGRect) {
        guard !children.isEmpty else { return }
        if let weights = weights {
            switch direction {
            case .horizontal:
                let widths = normalized(weights: weights).map() { $0 * rect.width }
                var x = rect.minX
                for (i, width) in widths.enumerated() {
                    children[i].layout(in: CGRect(x: x,
                                                  y: 0,
                                                  width: width,
                                                  height: rect.height))
                    x += width
                }
            case .vertical:
                let heights = normalized(weights: weights).map() { $0 * rect.height }
                var y = rect.minY
                for (i, height) in heights.enumerated() {
                    children[i].layout(in: CGRect(x: 0,
                                                  y: y,
                                                  width: rect.width,
                                                  height: height))
                    y += height
                }
            }
        } else {
            let length = 1 / CGFloat(children.count)
            switch direction {
            case .horizontal:
                for i in children.indices {
                    children[i].layout(in: CGRect(x: rect.minX + CGFloat(i) * length,
                                                  y: 0,
                                                  width: length,
                                                  height: rect.height))
                }
            case .vertical:
                for i in children.indices {
                    children[i].layout(in: CGRect(x: 0,
                                                  y: rect.minY + CGFloat(i) * length,
                                                  width: rect.width,
                                                  height: length))
                }
            }
        }
    }

    private func normalized(weights: [CGFloat]) -> [CGFloat] {
        let sum = weights.reduce(0) { $0 + $1 }
        guard sum != 0 else { return [] }
        if sum == 1 { return weights }
        return weights.map() { $0 / sum }
    }

}
