//
//  BubbleButton.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BubbleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBorder()
    }

    private func setupBorder() {
        layer.borderWidth = 1
        layer.borderColor = (titleColor(for: UIControlState()) ?? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)).cgColor
        layer.cornerRadius = frame.size.height / 2
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
}
