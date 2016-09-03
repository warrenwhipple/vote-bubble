//
//  NewBallotCell.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class NewBallotCell: UICollectionViewCell {

    override func didMoveToSuperview() {
        backgroundColor = ColorPalette.messageBackground
    }

    override func draw(_ rect: CGRect) {
        let smallestSide = min(bounds.width, bounds.height)
        Icon.plus.draw(
            center: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            diameter: smallestSide / 5,
            rotation: 0,
            strokeWidth: smallestSide / 16,
            strokeColor: UIColor.white
        )
    }
}
