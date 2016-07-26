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
        let paddedString: String
        switch base64String.characters.count {
        case 22: paddedString = base64String + "=="
        case 24: paddedString = base64String
        default: return nil
        }
        guard
            let data = Data(base64Encoded: paddedString),
            data.count == 16 else {
                return  nil
        }
        let bytes = [UInt8](repeatElement(0, count: 16))
        data.copyBytes(to: UnsafeMutablePointer(bytes), count: 16)
        let nsuuid = NSUUID(uuidBytes: UnsafePointer(bytes))
        self.init(uuidString: nsuuid.uuidString)
    }

    var base64String: String {
        let nsuuid = NSUUID(uuidString: uuidString)!
        let bytes = [UInt8](repeatElement(0, count: 16))
        nsuuid.getBytes(UnsafeMutablePointer(bytes))
        let paddedString = Data(bytes: bytes).base64EncodedString()
        return paddedString.substring(to: paddedString.index(paddedString.endIndex, offsetBy: -2))
    }
}
