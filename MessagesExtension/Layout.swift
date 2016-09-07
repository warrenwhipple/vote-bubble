//
//  Layout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import CoreGraphics

protocol Layout {
    @discardableResult
    func layout(in rect: CGRect) -> Self
}
