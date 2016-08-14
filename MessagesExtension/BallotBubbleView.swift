//
//  BallotBubbleView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/14/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BallotBubbleViewDelegate: class {
    var ballot: Ballot { get }
}

class BallotBubbleView: UIView {

    weak var delegate: BallotBubbleViewDelegate?
    var candidateBrickViews: [CandidateBrickView]
    var questionLabel: UILabel?

    init(ballot: Ballot) {
        candidateBrickViews = []
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
