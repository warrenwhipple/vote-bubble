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
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    override func draw(_ rect: CGRect) {
        let smallestSide = min(bounds.width, bounds.height)
        DrawIcon.plus(
            center: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
            diameter: smallestSide / 5,
            strokeWidth: smallestSide / 16,
            strokeColor: UIColor.white
        )
    }
}
