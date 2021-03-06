//
//  VoteBubbleMacOSTests.swift
//  VoteBubbleMacOSTests
//
//  Created by Warren Whipple on 9/7/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import XCTest

class VoteBubbleMacOSTests: XCTestCase {
    
    func testBricks() {
        for i in 1 ... 100 {
            let rect = CGRect(
                x: CGFloat.random(-1000 ..< 1000),
                y: CGFloat.random(-1000 ..< 1000),
                width: CGFloat.random(0.1 ..< 1000),
                height: CGFloat.random(0.1 ..< 1000)
            )
            let bricks = rect.bricks(count: i)
            XCTAssert(bricks.count == i)
        }
    }

    func testDataBase64EncodedForURL() {
        let datas: [Data] = (0 ... 1000).map { i in
            var data = Data(count: i)
            data.withUnsafeMutableBytes() { p in arc4random_buf(p, i) }
            return data
        }
        let encodedStrings = datas.map { $0.base64EncodedForURLString() }
        let decodedDatas = encodedStrings.flatMap { Data(base64EncodedForURL: $0) }
        XCTAssert(datas == decodedDatas)
    }

    func testUUIDBase64EncodedForURL() {
        let uuids: [UUID] = (0 ... 1000).map { _ in UUID() }
        let urlCompressedUUIDs: [URL] = uuids.map {
            let compressedString = $0.base64EncodedForURLString
            var components = URLComponents()
            let queryItem = URLQueryItem(name: "id", value: compressedString)
            components.queryItems = [queryItem]
            return components.url!
        }
        let decompressedUUIDs: [UUID] = urlCompressedUUIDs.flatMap {
            let components = URLComponents(url: $0, resolvingAgainstBaseURL: false)!
            let queryItems = components.queryItems!
            let idItem = queryItems.first!
            let compressedUUID = idItem.value!
            return UUID(base64EncodedForURL: compressedUUID)
        }
        XCTAssert(uuids == decompressedUUIDs)
    }

    func testEncryptionKey() {
        XCTAssert(EncryptionKey().bytes != EncryptionKey().bytes)
        let strings = (1...100).map { _ in String.random(Range(0...1000)) }
        let keys = (1...100).map { _ in EncryptionKey() }
        let encrypteds = zip(keys,strings).flatMap { $0.0.encrypt($0.1) }
        let decrypteds = zip(keys,encrypteds).flatMap { $0.0.decrypt($0.1) }
        XCTAssert(strings == decrypteds)
    }    
}
