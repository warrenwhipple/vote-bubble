//
//  Bubble.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/8/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

struct Bubble {
    var center: CGPoint
    var radius: CGFloat
    var shineRadius: CGFloat
    var strokeWidth: CGFloat
    var strokeColor: CGColor
    var fillColor: CGColor?

    init(center: CGPoint = CGPoint.zero,
         radius: CGFloat,
         shineRadius: CGFloat? = nil,
         strokeWidth: CGFloat? = nil,
         strokeColor: CGColor,
         fillColor: CGColor? = nil) {

        self.center = center
        self.radius = radius
        let strokeWidth = strokeWidth ?? radius / 8
        self.strokeWidth = strokeWidth
        self.shineRadius = shineRadius ?? radius - strokeWidth * 2
        self.strokeColor = strokeColor
        self.fillColor = fillColor
    }

    init(rect: CGRect,
         radius: CGFloat? = nil,
         strokeWidth: CGFloat? = nil,
         strokeColor: CGColor,
         fillColor: CGColor? = nil) {

        center = CGPoint(
            x: rect.origin.x + rect.width * 0.5,
            y: rect.origin.y + rect.height * 0.5
        )
        let strokeWidth = strokeWidth ?? min(rect.width, rect.height) / 17
        self.strokeWidth = strokeWidth
        let radius = radius ?? strokeWidth * 8
        self.radius = radius
        shineRadius = radius - strokeWidth * 2
        self.strokeColor = strokeColor
        self.fillColor = fillColor
    }

    func draw(context: CGContext?) {
        guard let context = context else { return }
        context.setLineWidth(strokeWidth)
        context.setLineCap(.round)
        context.setStrokeColor(strokeColor)
        let ellipseRect = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: 2 * radius,
            height: 2 * radius
        )
        if let fillColor = fillColor {
            context.setFillColor(fillColor)
            context.fillEllipse(in: ellipseRect)
        } else {
            context.strokeEllipse(in: ellipseRect)
        }
        context.addArc(
            centerX: center.x,
            y: center.y,
            radius: shineRadius,
            startAngle: CGFloat.pi * 7 / 6,
            endAngle: CGFloat.pi * 5 / 3,
            clockwise: 0
        )
        context.strokePath()
    }
}
