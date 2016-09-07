//
//  LayoutUnitTests.swift
//  VoteBubble
//
//  Created by Warren Whipple on 9/7/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import XCTest

private func product<T,U,V>(_ a: Array<T>, _ b: Array<U>, _ op: (T,U)->(V)) -> Array<V> {
    var array = Array<V>()
    array.reserveCapacity(a.count * b.count)
    for a in a { for b in b { array.append(op(a,b)) } }
    return array
}

private func unzip<T,U>(_ zipped: Array<(T,U)>) -> (Array<T>, Array<U>) {
    return (zipped.map({$0.0}), zipped.map({$0.1}))
}

private extension CGRect {
    var center: CGPoint {
        return CGPoint(x: (minX - width) / 2, y: (minY - height) / 2)
    }
}

private class MockLayout: Layout {
    var rect = CGRect.null
    var minX:   CGFloat { return rect.minX }
    var maxX:   CGFloat { return rect.maxX }
    var minY:   CGFloat { return rect.minY }
    var maxY:   CGFloat { return rect.maxY }
    var width:  CGFloat { return rect.width }
    var height: CGFloat { return rect.height }
    var center: CGPoint { return rect.center }
    @discardableResult
    func layout(in rect: CGRect) -> Self {
        self.rect = rect
        return self
    }
}

private let floats:   [CGFloat] = stride(from: -2, through: 2, by: 1/2).map { $0 }
private let floats01: [CGFloat] = stride(from:  0, through: 1, by: 1/8).map { $0 }
private let floats02: [CGFloat] = stride(from:  0, through: 2, by: 1/4).map { $0 }
private let points:   [CGPoint] = product(floats, floats)     { CGPoint(x: $0, y: $1) }
private let sizes:    [CGSize]  = product(floats02, floats02) { CGSize(width: $0, height: $1) }
private let rects:    [CGRect]  = product(points, sizes)      { CGRect(origin: $0, size: $1) }

class LayoutUnitTests: XCTestCase {

    func testSplitLayout() {
        let rectSplitPairs: [(CGRect, CGFloat)] = product(rects,floats01) { ($0, $1) }
        let mockA = MockLayout()
        let mockB = MockLayout()
        let horizontalABRectPairs: [(CGRect, CGRect)] = rectSplitPairs.map { (rect, split) in
            SplitLayout(mockA, mockB, split: split, direction: .horizontal).layout(in: rect)
            return (mockA.rect, mockB.rect)
        }
        let verticalABRectPairs: [(CGRect, CGRect)] = rectSplitPairs.map { (rect, split) in
            SplitLayout(mockA, mockB, split: split, direction: .vertical).layout(in: rect)
            return (mockA.rect, mockB.rect)
        }
        let A: [CGRect] // Parent
        let splits: [CGFloat]
        (A, splits) = unzip(rectSplitPairs)
        var B: [CGRect] // First child
        var C: [CGRect] // Second child
        // Horizontal B, C
        (B, C) = unzip(horizontalABRectPairs)
        XCTAssert(B.map { $0.width } == zip(A, splits).map { $0.0.width * $0.1 } )
        XCTAssert(A.map { $0.minX } == B.map { $0.minX } )
        XCTAssert(B.map { $0.maxX } == C.map { $0.minX } )
        XCTAssert(C.map { $0.maxX } == A.map { $0.maxX } )
        XCTAssert(C.map { $0.maxX } == A.map { $0.maxX } )
        XCTAssert(C.map { $0.minY } == B.map { $0.minY } )
        XCTAssert(A.map { $0.maxY } == B.map { $0.maxY } )
        XCTAssert(A.map { $0.minY } == C.map { $0.minY } )
        XCTAssert(A.map { $0.maxY } == C.map { $0.maxY } )
        // Vertical B, C
        (B, C) = unzip(verticalABRectPairs)
        XCTAssert(B.map { $0.height } == zip(A,splits).map { $0.0.height * $0.1 } )
        XCTAssert(A.map { $0.minY } == B.map { $0.minY } )
        XCTAssert(B.map { $0.maxY } == C.map { $0.minY } )
        XCTAssert(C.map { $0.maxY } == A.map { $0.maxY } )
        XCTAssert(C.map { $0.maxY } == A.map { $0.maxY } )
        XCTAssert(A.map { $0.minX } == B.map { $0.minX } )
        XCTAssert(A.map { $0.maxX } == B.map { $0.maxX } )
        XCTAssert(A.map { $0.minX } == C.map { $0.minX } )
        XCTAssert(A.map { $0.maxX } == C.map { $0.maxX } )
    }

    func testCenteredLayout() {
        let rectAspectRatioPairs: [(CGRect, CGFloat)] = product(rects, floats02) { ($0, $1) }

        let mock = MockLayout()
        let fit: [CGRect] = rectAspectRatioPairs.map { (rect, aspectRatio) in
            CenteredLayout(child: mock, mode: .aspectRatioFit(aspectRatio)).layout(in: rect)
            return mock.rect
        }
        let A:  [CGRect]  // Parent
        let Ar: [CGFloat] // Parent aspect ratio
        var B:  [CGRect]  // Child
        let Bs: [CGRect]  // Child size
        let Bm: [CGRect]  // Child size
        let Br: [CGFloat] // Child aspect ratio

        let (outer, aspect) = unzip(rectAspectRatioPairs)
        XCTAssert(fit.map { $0.center } ≈ outer.map { $0.center } )
    }
    
}
