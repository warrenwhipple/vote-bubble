//
//  CandidateView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/14/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class CandidateView: UIView {

    var candidateIndex: Int = 0

    let figureLabel = UILabel()
    let textLabel = InsetLabel()

    init(candidate: Candidate, candidateIndex: Int) {
        self.candidateIndex = candidateIndex
        super.init(frame: CGRect.zero)
        figureLabel.textAlignment = .center
        textLabel.textAlignment = .center
        switch candidate.figure {
        case .autoCharacter(let character): figureLabel.text = String(character)
        case .customCharacter(let character): figureLabel.text = String(character)
        case .none: break
        }
        if let text = candidate.text {
            textLabel.text = text
        }
        //backgroundColor = candidate.backgroundColor
        figureLabel.backgroundColor = candidate.backgroundColor
        textLabel.backgroundColor = candidate.backgroundColor
        figureLabel.textColor = candidate.textColor
        figureLabel.textColor = candidate.textColor
        addSubview(figureLabel)
        addSubview(textLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
