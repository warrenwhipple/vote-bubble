//
//  BallotView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BallotView: UIView {

    let bubbleView = BallotBubbleView()
    let brickStyleButtons: [IconButton] = [IconButton(), IconButton(), IconButton()]
    let addCandidateButton = IconButton()
    let subtractCandidateButton = IconButton()
    let backButton = IconButton()
    let toggleQuestionButton = IconButton()

    init() {
        super.init(frame: CGRect.zero)

        addSubview(bubbleView)

        addCandidateButton.icon = .plus
        addCandidateButton.backgroundColor = ColorPalette.voteBubblePrimary
        addCandidateButton.iconStrokeColor = UIColor.white
        addCandidateButton.clipsToBounds = true
        addSubview(addCandidateButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let controlStackDirection: StackLayout.Direction
        let overallStackDirection: StackLayout.Direction
        if bounds.width > bounds.height {
            controlStackDirection = .vertical
            overallStackDirection = .horizontal
        } else {
            controlStackDirection = .vertical
            overallStackDirection = .horizontal
        }
        let topControlLayout = StackLayout(
            spacedChildren: brickStyleButtons,
            all: .aspectRatio(1),
            direction: controlStackDirection
        )
        let bottomControls: [Layout] = [
            backButton,
            toggleQuestionButton,
            subtractCandidateButton,
            addCandidateButton
        ]
        let bottomControlsLayout = StackLayout(
            spacedChildren: bottomControls,
            all: .aspectRatio(1),
            direction: controlStackDirection
        )
    }
}
