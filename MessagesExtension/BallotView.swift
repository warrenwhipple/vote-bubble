//
//  BallotView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/17/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

private let maxMessageBubbleEdgeLength: CGFloat = 300
private let addButtonDiameter: CGFloat = 64
private let controlMargin: CGFloat = 8

protocol BallotViewDelegate: class {
    var ballot: Ballot { get }
}

class BallotView: UIView {

    weak var delegate: BallotViewDelegate?

    let bubbleView = UIView()
    

    init(ballot: Ballot) {
        self.buildingBallot = ballot
        bubbleView = BubbleView(ballot: ballot)
        super.init(frame: CGRect.zero)
        bubbleView.delegate = self
        addSubview(bubbleView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let smallestViewSide = min(bounds.width, bounds.height)
        let stretchBubbleSide = smallestViewSide - 20
        let bubbleSide = min(stretchBubbleSide, maxMessageBubbleEdgeLength)
        let bubbleSize = CGSize(
            width: bubbleSide,
            height: bubbleSide
        )
        bubbleView.frame = bounds.centeredRect(ofSize: bubbleSize)
    }

}
