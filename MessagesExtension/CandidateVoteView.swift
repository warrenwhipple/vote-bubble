//
//  CandidateVoteView.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/17/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol CandidateVoteViewDelegate: class {
    func vote(candidate: Candidate)
}

class CandidateVoteView: UIView {

    weak var delegate: CandidateVoteViewDelegate?
    var candidate: Candidate?
    var characterLabel, textLabel: UILabel?

    init(frame: CGRect, candidate: Candidate) {
        super.init(frame: frame)
        self.candidate = candidate
        backgroundColor = candidate.backgroundColor
        let figureCharacter: Character?
        switch candidate.figure {
        case .none:                           figureCharacter = nil
        case .autoCharacter(let character):   figureCharacter = character
        case .customCharacter(let character): figureCharacter = character
        }
        if let figureCharacter = figureCharacter {
            let label = UILabel()
            label.textColor = candidate.color
            label.textAlignment = .center
            label.text = String(figureCharacter)
            addSubview(label)
            characterLabel = label
        }
        if let text = candidate.text {
            let label = UILabel()
            label.textColor = candidate.color
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.text = text
            addSubview(label)
            textLabel = label
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(candidate: Candidate) {
        self.init(frame: CGRect.zero, candidate: candidate)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let characterLabel = characterLabel {
            if let textLabel = textLabel {
                characterLabel.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: bounds.width,
                    height: bounds.height * 2/3
                )
                textLabel.frame = CGRect(
                    x: 0,
                    y: characterLabel.frame.height,
                    width: bounds.width,
                    height: bounds.height - characterLabel.frame.height
                )
                textLabel.font = UIFont.systemFont(ofSize: textLabel.frame.height * 1/3)
            } else {
                characterLabel.frame = bounds
            }
            characterLabel.font = UIFont.systemFont(ofSize: characterLabel.frame.height * 2/3)
        } else {
            if let textLabel = textLabel {
                textLabel.frame = bounds
                textLabel.font = UIFont.systemFont(ofSize: textLabel.frame.height * 1/3)
            }
        }
    }
}
