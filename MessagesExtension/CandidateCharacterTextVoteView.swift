//
//  CandidateCharacterTextVoteView.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/16/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class CandidateCharacterTextVoteView: CandidateVoteView {
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!

    override func loadCandidate(_ candidate: Candidate) {
    super.loadCandidate(candidate)
        switch candidate.figure {
        case .autoCharacter(let character):   characterLabel.text = String(character)
        case .customCharacter(let character): characterLabel.text = String(character)
        default: break
        }
        textLabel.text = candidate.text
    }    
}
