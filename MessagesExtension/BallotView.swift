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
        let topControlsLayout = StackLayout(
            spacingChildren: brickStyleButtons,
            all: .aspectRatio(1),
            direction: .contextual,
            insideSpacing: .stretch(1)
        )
        let bottomControls = [
            backButton,
            toggleQuestionButton,
            subtractCandidateButton,
            addCandidateButton
        ]
        let bottomControlsLayout = StackLayout(
            spacingChildren: bottomControls,
            all: .aspectRatio(1),
            direction: .contextual,
            insideSpacing: .stretch(1)
        )
        let stackChildren: [Layout] = [
            topControlsLayout,
            bubbleView,
            bottomControlsLayout
        ]
        let stackModes: [StackLayout.Mode] = [
            .aspectRatio(0.25),
            .aspectRatio(1),
            .aspectRatio(0.25)
        ]
        let stackLayout = StackLayout(
            spacingChildren: stackChildren,
            modes: stackModes,
            direction: .contextual,
            insideSpacing: .stretch(1)
        )
        let centeredLayout = stackLayout
            .withCentering(.aspectRatioFit(0.75))
            .withCentering(.maxWidth(300))
            .withInsets(.absolute, all: 8)
        centeredLayout.layout(in: bounds)
    }
}
