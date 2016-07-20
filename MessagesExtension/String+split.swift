//
//  String+split.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/19/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

extension String {
    func split(componentLength: Int) -> [String] {
        assert(componentLength > 0)
        var componenets: [String] = []
        componenets.reserveCapacity(characters.count % componentLength)
        var i = startIndex
        while let j = index(i, offsetBy: componentLength, limitedBy: endIndex) {
            componenets.append(substring(with: i ..< j))
            i = j
        }
        return componenets
    }
}
