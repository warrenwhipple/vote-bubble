//
//  InsetLayout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/29/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct InsetLayout: Layout {

    enum Mode { case absolute, relative }

    var child: Layout
    var mode: Mode
    var left, right, top, bottom: CGFloat

    func layout(in rect: CGRect) {
        switch mode {
        case .absolute: child.layout(in: CGRect(
            x: rect.minX + left,
            y: rect.minY + top,
            width: rect.width - left - right,
            height: rect.height - top - bottom))
        case .relative: child.layout(in: CGRect(
            x: rect.minX + left * rect.width,
            y: rect.minY + top * rect.height,
            width: rect.width - (left + right) * rect.width,
            height: rect.height - (top + bottom) * rect.height))
        }
    }
}

extension Layout {

    func withInsets(mode: InsetLayout.Mode,
                    left: CGFloat = 0,
                    right: CGFloat = 0,
                    top: CGFloat = 0,
                    bottom: CGFloat = 0
        ) -> InsetLayout {
        return InsetLayout(child: self,
                           mode: mode,
                           left: left,
                           right: right,
                           top: top,
                           bottom: bottom)
    }

    func withInsets(mode: InsetLayout.Mode, all inset: CGFloat) -> InsetLayout {
        return InsetLayout(child: self,
                           mode: mode,
                           left: inset,
                           right: inset,
                           top: inset,
                           bottom: inset)
    }
}
