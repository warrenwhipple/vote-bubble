//
//  VoteBubbleTests.swift
//  VoteBubbleTests
//
//  Created by Warren Whipple on 7/19/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import XCTest

extension CGFloat {
    static func random(from lowInclusive: CGFloat = 0, to highExclusive: CGFloat = 1) -> CGFloat {
        let range = highExclusive - lowInclusive
        let randomZeroToOne = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return lowInclusive + randomZeroToOne * range
    }
}

class VoteBubbleTests: XCTestCase {

    func testBricks() {
        for n in 1 ... 100 {
            let rect = CGRect(
                x: CGFloat.random(from: -1000, to: 1000),
                y: CGFloat.random(from: -1000, to: 1000),
                width: CGFloat.random(from: 0.1, to: 1000),
                height: CGFloat.random(from: 0.1, to: 1000)
            )
            let bricks = rect.bricks(count: n)
            XCTAssert(bricks.count == n)
        }
    }

    func testUUIDBase64String() {
        let uuids = (0 ..< 1000).map { _ in UUID() }
        let compressedUUIDs = uuids.map { $0.base64String }
        let decompressedUUIDs = compressedUUIDs.flatMap { UUID(base64String: $0) }
        XCTAssert(uuids == decompressedUUIDs)
    }
}
