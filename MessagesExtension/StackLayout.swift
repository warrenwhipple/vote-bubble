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

    init(_ children: [Layout?], modes: [Mode], direction: Direction = .contextual) {
        self.children = children
        self.modes = modes
        self.direction = direction
    }

    init(children: [Layout?], all mode: Mode, direction: Direction = .contextual) {
        self.children = children
        self.modes = [Mode](repeatElement(mode, count: children.count))
        self.direction = direction
    }

    /// Inserts nil layouts between children
    init(
        spacingChildren: [Layout?],
        modes: [Mode],
        direction: Direction = .contextual,
        insideSpacing: Mode = .stretch(1),
        outsideSpacing: Mode? = nil
        ) {
        let (childrenPlusSpacers, modesPlusSpacers) = StackLayout.inertSpacers(
            children: spacingChildren,
            modes: modes,
            insideSpacing: insideSpacing,
            outsideSpacing: outsideSpacing
        )
        self.children = childrenPlusSpacers
        self.modes = modesPlusSpacers
        self.direction = direction
    }

    /// Inserts spacing between children
    init(
        spacingChildren: [Layout?],
        all mode: Mode,
        direction: Direction = .contextual,
        insideSpacing: Mode = .stretch(1),
        outsideSpacing: Mode? = nil
        ) {
        let (childrenPlusSpacers, modesPlusSpacers) = StackLayout.inertSpacers(
            children: spacingChildren,
            modes: [Mode](repeatElement(mode, count: spacingChildren.count)),
            insideSpacing: insideSpacing,
            outsideSpacing: outsideSpacing
        )
        self.children = childrenPlusSpacers
        self.modes = modesPlusSpacers
        self.direction = direction
    }

    private static func inertSpacers(
        children: [Layout?],
        modes: [Mode],
        insideSpacing: Mode,
        outsideSpacing: Mode?
        ) -> ([Layout?],[Mode]) {
        var childrenPlusSpacers: [Layout?] = []
        var modesPlusSpacers: [Mode] = []
        let minCount = min(children.count, modes.count)
        if let outsideSpacing = outsideSpacing {
            childrenPlusSpacers.reserveCapacity(minCount * 2 + 1)
            modesPlusSpacers.reserveCapacity(minCount * 2 + 1)
            childrenPlusSpacers.append(nil)
            modesPlusSpacers.append(outsideSpacing)
        } else {
            childrenPlusSpacers.reserveCapacity(minCount * 2 - 1)
            modesPlusSpacers.reserveCapacity(minCount * 2 - 1)
        }
        if minCount > 0 {
            childrenPlusSpacers.append(children[0])
            modesPlusSpacers.append(modes[0])
        }
        if minCount > 1 {
            for i in 1 ..< minCount {
                childrenPlusSpacers.append(nil)
                modesPlusSpacers.append(insideSpacing)
                childrenPlusSpacers.append(children[i])
                modesPlusSpacers.append(modes[i])
            }
        }
        if let outsideSpacing = outsideSpacing {
            childrenPlusSpacers.append(nil)
            modesPlusSpacers.append(outsideSpacing)
        }
        return (childrenPlusSpacers, modesPlusSpacers)
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
            case .stretch(let weight):
                guard !stretchSum.isZero else { return 0 }
                return stretchLength * weight / stretchSum
            case .aspectRatio(let aspectRatio):
                return aspectRatio * axisDepth
            }
        }
        let directionIsHorizontal: Bool = {
            switch direction {
            case .horizontal: return true
            case .vertical:   return false
            case .contextual: return (rect.width >= rect.height)
            }
        }()
        if directionIsHorizontal {
            var x = rect.minX
            let y = rect.minY
            let height = axisDepth
            for i in 0 ..< minCount {
                let width = childLengths[i]
                children[i]?.layout(in: CGRect(x: x, y: y, width: width, height: height))
                x += width
            }
        } else {
            let x = rect.minX
            var y = rect.minY
            let width = axisDepth
            for i in 0 ..< minCount {
                let height = childLengths[i]
                children[i]?.layout(in: CGRect(x: x, y: y, width: width, height: height))
                y += height
            }
        }
    }
}
