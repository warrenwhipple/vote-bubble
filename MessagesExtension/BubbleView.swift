//
//  BubbleView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/14/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BubbleViewDelegate: class {
    var ballot: Ballot { get }
}

class BubbleView: UIView {

    weak var delegate: BubbleViewDelegate!
    var candidateViews: [CandidateView]
    var questionLabel: InsetLabel?

    init(ballot: Ballot) {
        candidateViews = ballot.candidates.enumerated().map() {
            (i, candidate) in
            CandidateView(candidate: candidate, candidateIndex: i)
        }
        if let questionText = ballot.questionText {
            questionLabel = InsetLabel()
            questionLabel!.text = questionText
        } else {
            questionLabel = nil
        }
        super.init(frame: CGRect.zero)
        clipsToBounds = true
        layer.cornerRadius = 16
        for candidateView in candidateViews {
            addSubview(candidateView)
        }
        if let questionLabel = questionLabel {
            addSubview(questionLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var anyCandidateFigure = false
        for candidate in delegate.ballot.candidates {
            if candidate.figure != .none {
                anyCandidateFigure = true
                break
            }
        }
        var anyCandidateText = false
        for candidate in delegate.ballot.candidates {
            if candidate.text != nil {
                anyCandidateText = true
                break
            }
        }
        let candidatesRect: CGRect
        if let questionLabel = questionLabel {
            candidatesRect = CGRect(
                x: 0,
                y: 0,
                width: bounds.width,
                height: bounds.height * 0.75
            )
            questionLabel.frame = CGRect(
                x: 0,
                y: candidatesRect.height,
                width: bounds.width,
                height: bounds.height * 0.25
            )
        } else {
            candidatesRect = bounds
        }
        let brickRects = candidatesRect.bricks(count: candidateViews.count)
        let smallestBrickSize = brickRects.last?.size ?? candidatesRect.size
        let smallestBrickSide = min(smallestBrickSize.width, smallestBrickSize.height)
        let textInsets = UIEdgeInsets(
            top: smallestBrickSide * 0.0625,
            left: smallestBrickSide * 0.125,
            bottom: smallestBrickSide * 0.0625,
            right: smallestBrickSide * 0.125
        )
        if anyCandidateFigure && anyCandidateText {
            if smallestBrickSize.width < 4 * smallestBrickSize.height {
                // Layout figure above text
                let smallestFigureSide =
                    min(smallestBrickSize.width, smallestBrickSize.height * 0.75)
                let figureFont = UIFont.systemFont(ofSize: smallestFigureSide * 0.75)
                let textFont = UIFont.systemFont(ofSize: smallestBrickSize.height * 0.125)
                for (candidateView, brickRect) in zip(candidateViews, brickRects) {
                    candidateView.frame = brickRect
                    let centerRect = candidateView.bounds.centeredRect(ofSize: smallestBrickSize)
                    candidateView.figureLabel.frame = centerRect.topSlice(of: 0.75)
                    candidateView.figureLabel.font = figureFont
                    candidateView.textLabel.frame = centerRect.bottomSlice(of: 0.25)
                    candidateView.textLabel.font = textFont
                    candidateView.textLabel.textInsets = textInsets
                }
            } else {
                // Layout figure left of text
                let figureFont = UIFont.systemFont(ofSize: smallestBrickSize.height * 0.75)
                let textFont = UIFont.systemFont(ofSize: smallestBrickSize.height * 0.25)
                for (candidateView, brickRect) in zip(candidateViews, brickRects) {
                    candidateView.frame = brickRect
                    candidateView.figureLabel.frame = CGRect(
                        x: 0,
                        y: 0,
                        width: brickRect.height,
                        height: brickRect.height
                    )
                    candidateView.figureLabel.font = figureFont
                    candidateView.textLabel.frame = CGRect(
                        x: brickRect.height,
                        y: 0,
                        width: brickRect.width - brickRect.height,
                        height: brickRect.height
                    )
                    candidateView.textLabel.font = textFont
                    candidateView.textLabel.textInsets = textInsets
                }
            }
        } else if anyCandidateFigure {
            // Layout figure only
            let smallestSide = min(smallestBrickSize.width, smallestBrickSize.height)
            let figureFont = UIFont.systemFont(ofSize: smallestSide * 0.75)
            for (candidateView, brickRect) in zip(candidateViews, brickRects) {
                candidateView.frame = brickRect
                candidateView.figureLabel.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: brickRect.width,
                    height: brickRect.height
                )
                candidateView.figureLabel.font = figureFont
            }
        } else if anyCandidateText {
            // Layout text only
            let textFont = UIFont.systemFont(ofSize: smallestBrickSize.height * 0.25)
            for (candidateView, brickRect) in zip(candidateViews, brickRects) {
                candidateView.frame = brickRect
                candidateView.textLabel.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: brickRect.width,
                    height: brickRect.height
                )
                candidateView.textLabel.font = textFont
                candidateView.textLabel.textInsets = textInsets
            }
        } else {
            for (candidateView, brickRect) in zip(candidateViews, brickRects) {
                candidateView.frame = brickRect
            }
        }
    }

}
