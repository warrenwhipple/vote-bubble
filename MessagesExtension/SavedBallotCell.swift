//
//  SavedBallotCell.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class SavedBallotCell: UICollectionViewCell {

    var questionLabel: UILabel?
    var usedCandidateLabels: [UILabel] = []
    var unusedCandidateLabels: [UILabel] = []

    func load(ballot: Ballot) {

        // Setup question label
        if let questionText = ballot.questionText {
            if questionLabel == nil {
                questionLabel = UILabel()
                questionLabel!.backgroundColor = #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1)
                questionLabel!.text = questionText
            }
            if questionLabel!.superview != self {
                addSubview(questionLabel!)
            }
        } else if questionLabel?.superview == self {
            questionLabel!.removeFromSuperview()
        }

        // Setup candidate labels
        while usedCandidateLabels.count > ballot.candidates.count {
            let label = usedCandidateLabels.popLast()!
            label.removeFromSuperview()
            unusedCandidateLabels.append(label)
        }
        while usedCandidateLabels.count < ballot.candidates.count {
            if let label = unusedCandidateLabels.popLast() {
                addSubview(label)
                usedCandidateLabels.append(label)
            } else {
                let label = UILabel()
                label.textAlignment = .center
                label.isOpaque = true
                addSubview(label)
                usedCandidateLabels.append(label)
            }
        }
        for (candidate, label) in zip(ballot.candidates, usedCandidateLabels) {
            switch candidate.figure {
            case .autoCharacter(let character): label.text = String(character)
            case .customCharacter(let character): label.text = String(character)
            case .none: label.text = nil
            }
            label.textColor = candidate.color
            label.backgroundColor = candidate.backgroundColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let brickWallHeight: CGFloat
        if let questionLabel = questionLabel, questionLabel.superview == self {
            brickWallHeight = bounds.height * 0.75
            let questionLabelHeight = bounds.height * 0.25
            questionLabel.frame = CGRect(
                x: 0,
                y: brickWallHeight,
                width: bounds.width,
                height: questionLabelHeight
            )
            questionLabel.font = UIFont.systemFont(ofSize: questionLabelHeight * 0.75)
        } else {
            brickWallHeight = bounds.height
        }
        let brickWallRect = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: brickWallHeight
        )
        let brickRects = brickWallRect.bricks(count: usedCandidateLabels.count)
        let smallestSize = (brickRects.last ?? CGRect.zero).size
        let smallestSide = min(smallestSize.width, smallestSize.height)
        let brickFont = UIFont.systemFont(ofSize: smallestSide * 0.75)
        for (label, brickRect) in zip(usedCandidateLabels, brickRects) {
            label.frame = brickRect
            label.font = brickFont
        }
    }
}
