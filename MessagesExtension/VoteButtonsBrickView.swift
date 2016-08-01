//
//  VoteButtonsBrickView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class VoteButtonsBrickView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let brickRects = bounds.bricks(count: subviews.count)
        let smallBrickSize = brickRects.last?.size ?? bounds.size
        let smallEdge = min(smallBrickSize.width, smallBrickSize.height)
        for (subview, brickRect) in zip(subviews, brickRects) {
            subview.frame = brickRect
            guard let voteButton = subview as? VoteButton else { continue }
            voteButton.characterLabel?.font = UIFont.systemFont(ofSize: smallEdge / 2)
            voteButton.textLabel?.font = UIFont.systemFont(ofSize: smallEdge / 4)
        }
    }
}
