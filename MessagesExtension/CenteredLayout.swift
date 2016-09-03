//
//  CenteredLayout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct CenteredLayout: Layout {

    var child: Layout
    var size: CGSize

    mutating func layout(in rect: CGRect) {
            child.layout(in: CGRect(x: rect.minX + (rect.width - size.width) / 2,
                                    y: rect.minY + (rect.height - size.height) / 2,
                                    width: size.width,
                                    height: size.height))
    }
}

extension Layout {
    func centered(size: CGSize) -> CenteredLayout {
        return CenteredLayout(child: self, size: size)
    }
}
