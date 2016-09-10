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
    let brickModeButtons: [IconButton] = [IconButton(), IconButton(), IconButton(), IconButton()]
    let settingsButton = IconButton()
    let toggleQuestionButton = IconButton()
    let subtractCandidateButton = IconButton()
    let addCandidateButton = IconButton()

    init() {
        super.init(frame: CGRect.zero)
        addSubview(bubbleView)
        settingsButton.icon = .arrow
        addCandidateButton.icon = .plus
        subtractCandidateButton.icon = .minus
        let buttons: [IconButton] = brickModeButtons + [
            settingsButton,
            toggleQuestionButton,
            subtractCandidateButton,
            addCandidateButton
        ]
        for button in buttons {
            button.backgroundColor = UIColor.white
            button.borderColor = ColorPalette.uiBlue
            button.iconStrokeColor = ColorPalette.uiBlue
            button.dynamicIconDiameter = 3/8
            button.dynamicCornerRadius = 1/2
            button.iconStrokeWidth = 2
            button.borderWidth = 2
            button.clipsToBounds = true
            addSubview(button)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let topStackChildren: [Layout?] = brickModeButtons
        let bottomStackChildren: [Layout?] = [
            settingsButton,
            toggleQuestionButton,
            subtractCandidateButton,
            addCandidateButton
        ]
        let topButtonStackLayout = StackLayout(
            spacingChildren: topStackChildren,
            all: .aspectRatio(1)
        )
        let bottomButtonStackLayout = StackLayout(
            spacingChildren: bottomStackChildren,
            all: .aspectRatio(1)
        )
        let fullStackChildren: [Layout?] = [
            topButtonStackLayout,
            bubbleView,
            bottomButtonStackLayout
        ]

        // 4 square buttons + 3 * 1/4 spacers between buttons
        // 1 / (16/4 + 3/4)
        let barAspectRatio: CGFloat = 4 / 19

        let fullStackModes: [StackLayout.Mode] = [
            .aspectRatio(barAspectRatio),
            .aspectRatio(1),
            .aspectRatio(barAspectRatio)
        ]

        let fullStackLayout = StackLayout(
            spacingChildren: fullStackChildren,
            modes: fullStackModes,
            direction: .contextual,
            insideSpacing: .stretch(1),
            outsideSpacing: .stretch(1)
        )

        // 2 * 4/19 bars + 1 square message + 4 * 1/19 spacers inside and outside
        // 1 / (8/19 + 19/19 + 4/19)
        let fullAspectRatio: CGFloat = 19 / 31

        let centeredLayout = fullStackLayout.withCentering(.aspectRatioFit(fullAspectRatio))

        centeredLayout.layout(in: bounds)
    }
}
