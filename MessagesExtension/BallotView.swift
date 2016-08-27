//
//  BallotView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/17/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

private let maxBubbleSide: CGFloat = 300
private let addButtonDiameter: CGFloat = 64
private let controlMargin: CGFloat = 8

protocol BallotViewDelegate: class {
}

class BallotView: UIView, BubbleViewDelegate {

    weak var delegate: BallotViewDelegate?

    var buildingBallot: Ballot?
    var election: Election?

    var ballot: Ballot {
        if let buildingBallot = buildingBallot {
            return buildingBallot
        } else if let election = election {
            return election.ballot
        } else {
            fatalError("No building ballot or election")
        }
    }

    let bubbleView: BubbleView
    var addButton: UIButton? = nil

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
        let bubbleSide = min(stretchBubbleSide, maxBubbleSide)
        let bubbleSize = CGSize(
            width: bubbleSide,
            height: bubbleSide
        )
        bubbleView.frame = bounds.centeredRect(ofSize: bubbleSize)
    }

}
