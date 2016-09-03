//
//  BallotView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BallotView: UIView {

    var ballotBubbleView = BallotBubbleView()

    init() {
        super.init(frame: CGRect.zero)
        addSubview(ballotBubbleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let smallestSide = min(bounds.width, bounds.height)
        let bubbleSide = min(smallestSide - 16, 300)
        var layout = ballotBubbleView.centered(size: CGSize(width: bubbleSide, height: bubbleSide))
        layout.layout(in: bounds)
    }

    
}
