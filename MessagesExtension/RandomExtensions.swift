//
//  RandomExtensions.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

extension Float {
    static func random(_ range: Range<Float>) -> Float {
        let span = range.upperBound - range.lowerBound
        let randomZeroToOne = Float(arc4random()) / Float(UInt32.max)
        return range.lowerBound + (randomZeroToOne * span)
    }
}

extension CGFloat {
    static func random(_ range: Range<CGFloat>) -> CGFloat {
        let span = range.upperBound - range.lowerBound
        let randomZeroToOne = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return range.lowerBound + (randomZeroToOne * span)
    }
}

extension Int {
    static func random(_ range: Range<Int>) -> Int {
        let span = range.upperBound - range.lowerBound
        return range.lowerBound + Int(arc4random_uniform(UInt32(span)))
    }
}

extension String {
    static func random(_ lengthRange: Range<Int>, characters: String? = nil) -> String {
        let characterArray: [Character]
        if let characters = characters {
            characterArray = [Character](characters.characters)
        } else {
            characterArray = [Character]("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`~!@#$%^&*()-_=+[]{};':\"\\|,./<>?😀😬😁😂😚😜😝😛👇👨‍👩‍👧👨‍👨‍👧‍👦🐸🐝🌵☄️🌨🍝🍛".characters)
        }
        var randomString = ""
        for _ in 0 ... Int.random(lengthRange) {
            randomString.append(characterArray[Int(arc4random_uniform(UInt32(characterArray.count)))])
        }
        return randomString
    }
}
