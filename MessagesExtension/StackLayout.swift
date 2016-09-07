//
//  StackLayout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct StackLayout: Layout {

    /// Layout axis direction
    enum Direction {
        case horizontal
        case vertical
        /// Layout in the longer direction, defaults to horizontal if square
        case contextual
    }

    /// How the axis alinged length of a child is determined
    enum Mode {
        /// Stretch to fill by weight
        case stretch(CGFloat)
        /// Axis alinged aspect ratio
        case aspectRatio(CGFloat)
    }

    var children: [Layout?]
    var modes: [Mode]
    var direction: Direction

    init(_ children: [Layout?], modes: [Mode], direction: Direction) {
        self.children = children
        self.modes = modes
        self.direction = direction
    }

    init(children: [Layout?], all mode: Mode, direction: Direction) {
        self.children = children
        self.modes = [Mode](repeatElement(mode, count: children.count))
        self.direction = direction
    }

    /// Inserts spacing between children
    init(
        spacingChildren: [Layout?],
        modes: [Mode],
        direction: Direction,
        insideSpacing: Mode,
        outsideSpacing: Mode? = nil
        ) {
        let (childrenPlusSpacing, modesPlusSpacing) = StackLayout.spacing(
            children: spacingChildren,
            modes: modes,
            insideSpacing: insideSpacing,
            outsideSpacing: outsideSpacing
        )
        self.children = childrenPlusSpacing
        self.modes = modesPlusSpacing
        self.direction = direction
    }

    /// Inserts spacing between children
    init(
        spacingChildren: [Layout?],
        all mode: Mode,
        direction: Direction,
        insideSpacing: Mode,
        outsideSpacing: Mode? = nil
        ) {
        let (childrenPlusSpacing, modesPlusSpacing) = StackLayout.spacing(
            children: spacingChildren,
            modes: [Mode](repeatElement(mode, count: spacingChildren.count)),
            insideSpacing: insideSpacing,
            outsideSpacing: outsideSpacing
        )
        self.children = childrenPlusSpacing
        self.modes = modesPlusSpacing
        self.direction = direction
    }

    private static func spacing(
        children: [Layout?],
        modes: [Mode],
        insideSpacing: Mode,
        outsideSpacing: Mode?
        ) -> ([Layout?],[Mode]) {
        var childrenPlusSpacing: [Layout?] = []
        var modesPlusSpacing: [Mode] = []
        let minCount = min(children.count, modes.count)
        if let outsideSpacing = outsideSpacing {
            childrenPlusSpacing.reserveCapacity(minCount * 2 + 1)
            modesPlusSpacing.reserveCapacity(minCount * 2 + 1)
            childrenPlusSpacing.append(nil)
            modesPlusSpacing.append(outsideSpacing)
        } else {
            childrenPlusSpacing.reserveCapacity(minCount * 2 - 1)
            modesPlusSpacing.reserveCapacity(minCount * 2 - 1)
        }
        if minCount > 0 {
            childrenPlusSpacing.append(children[0])
            modesPlusSpacing.append(modes[0])
        }
        if minCount > 1 {
            for i in 0 ..< minCount {
                childrenPlusSpacing.append(nil)
                modesPlusSpacing.append(insideSpacing)
                childrenPlusSpacing.append(children[i])
                modesPlusSpacing.append(modes[i])
            }
        }
        if let outsideSpacing = outsideSpacing {
            childrenPlusSpacing.append(nil)
            modesPlusSpacing.append(outsideSpacing)
        }
        return (childrenPlusSpacing, modesPlusSpacing)
    }

    func layout(in rect: CGRect) {
        let minCount = min(children.count, modes.count)
        guard minCount > 0 else { return }
        var stretchSum: CGFloat = 0
        var aspectRatioSum: CGFloat = 0
        for mode in modes {
            switch mode {
            case .stretch(let weight): stretchSum += weight
            case .aspectRatio(let aspectRatio): aspectRatioSum += aspectRatio
            }
        }
        let axisLength: CGFloat = {
            switch direction {
            case .horizontal: return rect.width
            case .vertical: return rect.height
            case .contextual: return max(rect.width, rect.height)
            }
        }()
        let axisDepth: CGFloat = {
            switch direction {
            case .horizontal: return rect.height
            case .vertical: return rect.width
            case .contextual: return min(rect.width, rect.height)
            }
        }()
        let stretchLength = axisLength - axisDepth * aspectRatioSum
        let childLengths: [CGFloat] = modes.map { mode in
            switch mode {
            case .stretch(let weight): return stretchLength * weight / stretchSum
            case .aspectRatio(let aspectRatio): return aspectRatio * axisDepth
            }
        }
        let directionIsHorizontal: Bool = {
            switch direction {
            case .horizontal: return true
            case .vertical: return false
            case .contextual: return (rect.height > rect.width)
            }
        }()
        if directionIsHorizontal {
            var x = rect.minX
            for i in 0 ..< minCount {
                let width = childLengths[i]
                children[i]?.layout(in: CGRect(x: x, y: 0, width: width, height: axisDepth))
                x += width
            }
        } else {
            var y = rect.minY
            for i in 0 ..< minCount {
                let height = childLengths[i]
                children[i]?.layout(in: CGRect(x: 0, y: y, width: axisDepth, height: height))
                y += height
            }
        }
    }
}
