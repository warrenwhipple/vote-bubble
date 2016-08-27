//
//  DrawIcon.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/22/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

enum DrawIcon {

    static func plus(center: CGPoint,
                     diameter: CGFloat,
                     strokeWidth: CGFloat,
                     strokeColor: UIColor) {

        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: center.x - diameter,
            y: center.y))
        path.addLine(to: CGPoint(
            x: center.x + diameter,
            y: center.y))
        path.move(to: CGPoint(
            x: center.x,
            y: center.y - diameter))
        path.addLine(to: CGPoint(
            x: center.x,
            y: center.y - strokeWidth / 2))
        path.move(to: CGPoint(
            x: center.x,
            y: center.y + strokeWidth / 2))
        path.addLine(to: CGPoint(
            x: center.x,
            y: center.y + diameter))
        path.lineWidth = strokeWidth
        strokeColor.setStroke()
        path.stroke()
    }

    static func arrow(center: CGPoint,
                      diameter: CGFloat,
                      rotation: CGFloat,
                      strokeWidth: CGFloat,
                      strokeColor: UIColor) {
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: -strokeWidth / 2,
            y: 0))
        path.addLine(to: CGPoint(
            x: diameter / 2,
            y: 0))
        path.move(to: CGPoint(
            x:0,
            y: strokeWidth / 2))
        path.addLine(to: CGPoint(
            x: 0,
            y: diameter / 2))
        let t1 = CGAffineTransform(translationX: -diameter / 8, y: -diameter / 8)
        let t2 = CGAffineTransform(rotationAngle: (rotation - 45) / 180 * CGFloat.pi)
        let t3 = CGAffineTransform(translationX: center.x, y: center.y)
        let t = t1.concatenating(t2).concatenating(t3)
        path.apply(t)
        path.lineWidth = strokeWidth
        strokeColor.setStroke()
        path.stroke()
    }
}
