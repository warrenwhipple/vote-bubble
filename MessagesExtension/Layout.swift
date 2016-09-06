//
//  Layout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol Layout {
    func layout(in rect: CGRect)
}

extension UIView: Layout {
    func layout(in rect: CGRect) {
        self.frame = rect
    }
}

struct PlaceHolderLayout: Layout {
    func layout(in rect: CGRect) {}
}
