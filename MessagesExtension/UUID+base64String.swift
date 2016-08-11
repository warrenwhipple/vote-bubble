//
//  UUID+base64String.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/25/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation

extension UUID {

    init?(base64EncodedForURL: String) {
        guard let data = Data(base64EncodedForURL: base64EncodedForURL) else { return nil }
        guard data.count == 16 else { return nil }
        self = data.withUnsafeBytes() { NSUUID(uuidBytes: $0) as UUID }
    }

    var base64EncodedForURLString: String {
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        (self as NSUUID).getBytes(bytes)
        let data = Data(bytesNoCopy: bytes, count: 16, deallocator: .free)
        return data.base64EncodedForURLString()
    }
}
