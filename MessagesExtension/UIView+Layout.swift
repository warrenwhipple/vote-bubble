//
//  UIView+Layout.swift
//  VoteBubble
//
//  Created by Warren Whipple on 9/6/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

extension UIView: Layout {
    @discardableResult
    func layout(in rect: CGRect) -> Self {
        self.frame = rect
        return self
    }
}
