//
//  AlmostEqual.swift
//  VoteBubble
//
//  Created by Warren Whipple on 9/7/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

private let precision: CGFloat = 0.0001

infix operator ≈ : ComparisonPrecedence

func ≈(_ a: CGFloat, _ b: CGFloat) -> Bool {
    return a < b + precision && a > b - precision
}

func ≈(_ a: CGPoint, _ b: CGPoint) -> Bool {
    return a.x ≈ b.x && a.y ≈ b.y
}

func ≈(_ a: CGSize, _ b: CGSize) -> Bool {
    return a.width ≈ b.width && a.height ≈ b.height
}

func ≈(_ a: CGRect, _ b: CGRect) -> Bool {
    return a.origin ≈ b.origin && a.size ≈ b.size
}

func ≈(_ a: [CGFloat], _ b: [CGFloat]) -> Bool {
    for (a, b) in zip(a, b) { if !(a ≈ b) { return false } }
    return true
}

func ≈(_ a: [CGPoint], _ b: [CGPoint]) -> Bool {
    for (a, b) in zip(a, b) { if !(a ≈ b) { return false } }
    return true
}

func ≈(_ a: [CGSize], _ b: [CGSize]) -> Bool {
    for (a, b) in zip(a, b) { if !(a ≈ b) { return false } }
    return true
}

func ≈(_ a: [CGRect], _ b: [CGRect]) -> Bool {
    for (a, b) in zip(a, b) { if !(a ≈ b) { return false } }
    return true
}
