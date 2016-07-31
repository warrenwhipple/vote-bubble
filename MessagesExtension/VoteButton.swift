//
//  VoteButton.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/17/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol VoteButtonDelegate: class {
    func vote(for candidateIndex: Int)
}

class VoteButton: UIButton {

    weak var delegate: VoteButtonDelegate!
    let candidate: Candidate
    let candidateIndex: Int
    let characterLabel, textLabel: UILabel?

    init(frame: CGRect, delegate: VoteButtonDelegate, candidate: Candidate, candidateIndex: Int) {
        self.delegate = delegate
        self.candidate = candidate
        self.candidateIndex = candidateIndex
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
            characterLabel = label
        } else {
            characterLabel = nil
        }
        if let text = candidate.text {
            let label = UILabel()
            label.textColor = candidate.color
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.text = text
            textLabel = label
        } else {
            textLabel = nil
        }
        super.init(frame: frame)
        addTarget(
            self,
            action: #selector(VoteButton.primaryActionTriggered),
            for: .primaryActionTriggered
        )
        backgroundColor = candidate.backgroundColor
        if let characterLabel = characterLabel {
            addSubview(characterLabel)
        }
        if let textLabel = textLabel {
            addSubview(textLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func primaryActionTriggered() {
        delegate.vote(for: candidateIndex)
    }
}
