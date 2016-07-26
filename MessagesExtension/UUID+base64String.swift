//
//  UUID+base64String.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/25/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation

extension UUID {

    init?(base64String: String) {
        let paddedBase64String: String
        switch base64String.characters.count {
        case 22: paddedBase64String = base64String + "=="
        case 24: paddedBase64String = base64String
        default: return nil
        }
        guard let data = Data(base64Encoded: paddedBase64String) else { return nil }
        guard data.count == 16 else { return nil }
        var nsuuid: NSUUID!
        data.withUnsafeBytes() { nsuuid = NSUUID(uuidBytes: $0) }
        self.init(uuidString: nsuuid.uuidString)
    }

    var base64String: String {
        let nsuuid = NSUUID(uuidString: uuidString)!
        let bytes = UnsafeMutablePointer<UInt8>(allocatingCapacity: 16)
        nsuuid.getBytes(bytes)
        let data = Data(
            bytesNoCopy: bytes,
            count: 16,
            deallocator: .free
        )
        let paddedBase64String = data.base64EncodedString()
        let unpaddedEndIndex = paddedBase64String.index(paddedBase64String.endIndex, offsetBy: -2)
        return paddedBase64String.substring(to: unpaddedEndIndex)
    }
}
