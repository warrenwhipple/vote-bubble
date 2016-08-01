//
//  BallotCollectionViewCell.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/29/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BallotCollectionViewCell: UICollectionViewCell {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet var candidateBrickView: CandidatesThumbnailBrickView!
    @IBOutlet var questionLabel: UILabel!
    var usedCandidateLabels: [UILabel] = []
    var unusedCandidateLabels: [UILabel] = []

    func load(ballot: Ballot) {
        while usedCandidateLabels.count > ballot.candidates.count {
            let label = usedCandidateLabels.popLast()!
            label.removeFromSuperview()
            unusedCandidateLabels.append(label)
        }
        while usedCandidateLabels.count < ballot.candidates.count {
            if let label = unusedCandidateLabels.popLast() {
                candidateBrickView.addSubview(label)
                usedCandidateLabels.append(label)
            } else {
                let label = UILabel()
                label.textAlignment = .center
                label.isOpaque = true
                candidateBrickView.addSubview(label)
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
}
