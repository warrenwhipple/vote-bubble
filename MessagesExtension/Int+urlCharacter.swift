//
//  Int+urlCharacter.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/19/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

extension Int {
    // utf(0) = 48
    // utf(A) = 65
    // utf(a) = 97
    var urlCharacter: Character? {
        switch self {
        case  0 ...  9: return Character(UnicodeScalar(self + 48))
        case 10 ... 35: return Character(UnicodeScalar(self + 55))
        case 36 ... 61: return Character(UnicodeScalar(self + 61))
        default:      return nil
        }
    }
    init?(urlCharacter: Character) {
        guard let v = String(urlCharacter).unicodeScalars.first?.value else { return nil }
        switch  v {
        case 48 ...  57: self.init(v - 48)
        case 65 ...  90: self.init(v - 55)
        case 97 ... 122: self.init(v - 61)
        default: return nil
        }
    }
}
