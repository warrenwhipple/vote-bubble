//
//  Icon.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/24/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

enum Icon {

    case none, plus, arrow

    func draw(center: CGPoint,
              diameter: CGFloat,
              rotation: CGFloat,
              strokeWidth: CGFloat,
              strokeColor: UIColor) {

        let path: UIBezierPath

        switch self {
        case .none: return
        case .plus:  path =      plusPath(diameter: diameter, strokeWidth: strokeWidth)
        case .arrow: path = leftArrowPath(diameter: diameter, strokeWidth: strokeWidth)
        }

        let t1 = CGAffineTransform(rotationAngle: rotation * CGFloat.pi / 180)
        let t2 = CGAffineTransform(translationX: center.x, y: center.y)
        path.apply(t1.concatenating(t2))

        path.lineWidth = strokeWidth
        strokeColor.setStroke()

        path.stroke()
    }

    private func plusPath(diameter: CGFloat, strokeWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move   (to: CGPoint(x: -diameter / 2, y: 0))
        path.addLine(to: CGPoint(x:  diameter / 2, y: 0))
        path.move   (to: CGPoint(x: 0, y: -diameter / 2))
        path.addLine(to: CGPoint(x: 0, y: -strokeWidth / 2))
        path.move   (to: CGPoint(x: 0, y:  strokeWidth / 2))
        path.addLine(to: CGPoint(x: 0, y:  diameter / 2))
        return path
    }

    private func leftArrowPath(diameter: CGFloat, strokeWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -strokeWidth / 2, y: 0))
        path.addLine(to: CGPoint(x: diameter / 2, y: 0))
        path.move(to: CGPoint(x:0, y: strokeWidth / 2))
        path.addLine(to: CGPoint(x: 0, y: diameter / 2))
        let t1 = CGAffineTransform(translationX: -diameter / 8, y: -diameter / 8)
        let t2 = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        path.apply(t1.concatenating(t2))
        return path
    }
    
}
