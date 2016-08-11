//
//  Data+base64URLString.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/8/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation

extension Data {

    init?(base64EncodedForURL: String) {
        let replaced = base64EncodedForURL
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let replacedPadded: String
        switch replaced.characters.count % 4 {
        case 2:  replacedPadded = replaced + "=="
        case 3:  replacedPadded = replaced + "="
        default: replacedPadded = replaced
        }
        self.init(base64Encoded: replacedPadded)
    }

    func base64EncodedForURLString() -> String {
        let encoded = base64EncodedString()
        let encodedClipped: String
        switch count % 3 {
        case 1: encodedClipped = encoded.substring(to: encoded.index(encoded.endIndex, offsetBy: -2))
        case 2: encodedClipped = encoded.substring(to: encoded.index(encoded.endIndex, offsetBy: -1))
        default: encodedClipped = encoded
        }
        let encodedClippedReplaced = encodedClipped
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
        return encodedClippedReplaced
    }
    
}
