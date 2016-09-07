//
//  CenteredLayout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct CenteredLayout: Layout {

    enum Mode {
        case size(CGSize)
        case maxSize(CGSize)
        case maxWidth(CGFloat)
        case maxHeight(CGFloat)
        case aspectRatioFit(CGFloat)
        case aspectRatioCover(CGFloat)
    }

    var child: Layout
    var mode: Mode

    @discardableResult
    func layout(in rect: CGRect) -> CenteredLayout {
        let size = childSize(in: rect.size, mode: self.mode)
        child.layout(in: CGRect(
            x: rect.minX + (rect.width - size.width) / 2,
            y: rect.minY + (rect.height - size.height) / 2,
            width: size.width,
            height: size.height
        ))
        return self
    }

    private func childSize(in parentSize: CGSize, mode: Mode) -> CGSize {
        switch mode {
        case .size(let size):
            return size
        case .maxSize(let maxSize):
            return CGSize(
                width: min(parentSize.width, maxSize.width),
                height: min(parentSize.height, maxSize.height)
            )
        case .maxWidth(let maxWidth):
            return CGSize(
                width: min(parentSize.width, maxWidth),
                height: parentSize.height
            )
        case .maxHeight(let maxHeight):
            return CGSize(
                width: parentSize.width,
                height: min(parentSize.height, maxHeight)
            )
        case .aspectRatioFit(let aspectRatio):
            let parentAspectRatio = parentSize.width / parentSize.height
            if parentAspectRatio > aspectRatio {
                return CGSize(
                    width: parentSize.height * aspectRatio,
                    height: parentSize.height
                )
            } else {
                return CGSize(
                    width: parentSize.width,
                    height: parentSize.width / aspectRatio
                )
            }
        case .aspectRatioCover(let aspectRatio):
            let parentAspectRatio = parentSize.width / parentSize.height
            if parentAspectRatio > aspectRatio {
                return CGSize(
                    width: parentSize.width,
                    height: parentSize.width / aspectRatio
                )
            } else {
                return CGSize(
                    width: parentSize.height * aspectRatio,
                    height: parentSize.height
                )
            }
        }
    }
}

extension Layout {
    func withCentering(_ mode: CenteredLayout.Mode) -> CenteredLayout {
        return CenteredLayout(child: self, mode: mode)
    }
}
