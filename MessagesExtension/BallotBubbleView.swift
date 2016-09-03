//
//  BallotBubbleView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BallotBubbleView: UIView {

    private(set) var candidateViews: [SynchronizedFigureCaptionView] = []
    private(set) var questionLabel: UILabel?
    var shouldDiplayFigures = true;
    var shouldDisplayText = true;

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = ColorPalette.messageBackground
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func add(candidateView: SynchronizedFigureCaptionView) {
        candidateViews.append(candidateView)
        if let questionLabel = questionLabel {
            insertSubview(candidateView, aboveSubview: questionLabel)
        } else {
            addSubview(candidateView)
        }
    }

    func add(questionLabel: UILabel) {
        self.questionLabel = questionLabel
        addSubview(questionLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 16
        let brickLayout = BrickLayout(children: candidateViews)
        var layout: Layout
        var brickWallSize: CGSize
        if let questionLabel = questionLabel {
            let splitLayout = SplitLayout(
                firstChild: brickLayout,
                secondChild: questionLabel.withInsets(mode: .relative, all: 0.1),
                split: 0.75,
                direction: .vertical
            )
            layout = splitLayout
            brickWallSize = splitLayout.firstSize(in: bounds.size)
        } else {
            layout = brickLayout
            brickWallSize = bounds.size
        }
        let smallBrickSize = brickLayout.smallestBrick(in: brickWallSize)
        let displayStyle: FigureCaptionDisplayStyle
        let figureFont: UIFont?
        let captionFont: UIFont?
        if shouldDiplayFigures && shouldDisplayText {
            if smallBrickSize.width > 2 * smallBrickSize.height {
                displayStyle = .figureLeftOfCaption
                figureFont = UIFont.systemFont(ofSize: smallBrickSize.height * 0.75)
                captionFont = UIFont.systemFont(ofSize: smallBrickSize.height * 0.25)
            } else {
                displayStyle = .figureOverCaption
                figureFont = UIFont.systemFont(ofSize: smallBrickSize.height * 0.5625)
                captionFont = UIFont.systemFont(ofSize: smallBrickSize.height * 0.1875)
            }
        } else if shouldDiplayFigures {
            displayStyle = .figureOnly
            figureFont = UIFont.systemFont(ofSize: smallBrickSize.height * 0.75)
            captionFont = nil
        } else if shouldDisplayText {
            displayStyle = .captionOnly
            figureFont = nil
            captionFont = UIFont.systemFont(ofSize: smallBrickSize.height * 0.25)
        } else {
            displayStyle = .none
            figureFont = nil
            captionFont = nil
        }
        for candidateView in candidateViews {
            candidateView.displayStyle = displayStyle
            candidateView.figureFont = figureFont
            candidateView.captionFont = captionFont
            candidateView.smallSynchSize = smallBrickSize
        }
        layout.layout(in: bounds)
    }

    
}
