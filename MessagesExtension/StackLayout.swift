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

    /// How the axis alinged length of the child is determined
    enum Mode {
        /// Stretch to fill by weight
        case stretch(CGFloat)
        /// Axis alinged aspect ratio
        case aspectRatio(CGFloat)
    }

    var childModePairs: [(Layout, Mode)]
    var direction: Direction

    init(childModePairs: [(Layout, Mode)], direction: Direction) {
        self.childModePairs = childModePairs
        self.direction = direction
    }

    init(children: [Layout], all mode: Mode, direction: Direction) {
        let modes: [Mode] = [Mode](repeatElement(mode, count: children.count))
        self.childModePairs = Array(zip(children, modes))
        self.direction = direction
    }

    /// Inserts placeholder spacers between children, each Mode.stretchWeighted(1)
    init(spacedChildren: [Layout],
         all mode: Mode,
         direction: Direction,
         outsideSpacing: CGFloat = 0) {

        self.direction = direction
        var childModePairs: [(Layout, Mode)] = []
        if outsideSpacing != 0 {
            childModePairs.reserveCapacity(spacedChildren.count * 2 + 1)
            childModePairs.append((PlaceHolderLayout(), .stretch(outsideSpacing)))
        } else {
            childModePairs.reserveCapacity(spacedChildren.count * 2 - 1)
        }
        for child in spacedChildren[1 ..< spacedChildren.count] {
            childModePairs.append((PlaceHolderLayout(), .stretch(1)))
            childModePairs.append((child, mode))
        }
        if outsideSpacing != 0 {
            childModePairs.append((PlaceHolderLayout(), .stretch(outsideSpacing)))
        }
        self.childModePairs = childModePairs
    }

    func layout(in rect: CGRect) {
        guard !childModePairs.isEmpty else { return }
        var stretchSum: CGFloat = 0
        var aspectRatioSum: CGFloat = 0
        for (_, mode) in childModePairs {
            switch mode {
            case .stretch(let weight): stretchSum += weight
            case .aspectRatio(let aspectRatio): aspectRatioSum += aspectRatio
            }
        }
        let axisLength: CGFloat = {
            switch direction {
            case .horizontal: return rect.width
            case .vertical: return rect.height
            }
        }()
        let axisDepth: CGFloat = {
            switch direction {
            case .horizontal: return rect.height
            case .vertical: return rect.width
            }
        }()
        let stretchLength = axisLength - axisDepth * aspectRatioSum
        let childLengths: [CGFloat] = childModePairs.map { (_, mode) in
            switch mode {
            case .stretch(let weight): return stretchLength * weight / stretchSum
            case .aspectRatio(let aspectRatio): return aspectRatio * axisDepth
            }
        }
        switch direction {
        case .horizontal:
            var x = rect.minX
            for i in 0 ..< childModePairs.count {
                let child = childModePairs[i].0
                let width = childLengths[i]
                child.layout(in: CGRect(x: x, y: 0, width: width, height: axisDepth))
                x += width
            }
        case .vertical:
            var y = rect.minY
            for i in 0 ..< childModePairs.count {
                let child = childModePairs[i].0
                let height = childLengths[i]
                child.layout(in: CGRect(x: 0, y: y, width: axisDepth, height: height))
                y += height
            }
        }
    }
}
