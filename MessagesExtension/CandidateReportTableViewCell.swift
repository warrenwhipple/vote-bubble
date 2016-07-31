//
//  CandidateReportTableViewCell.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/26/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol CandidateReportTableViewCellDelegate: class {
    
}

class CandidateReportTableViewCell: UITableViewCell {

    @IBOutlet var figureLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var candidateTextLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!

    private(set) weak var delegate: CandidateReportTableViewCellDelegate!
    private(set) var candidate: Candidate!

    func load(delegate: CandidateReportTableViewCellDelegate,
              candidate: Candidate,
              candidateVoteCount: Int) {
        self.delegate = delegate
        load(candidate: candidate, candidateVoteCount: candidateVoteCount)
    }

    private func load(candidate: Candidate, candidateVoteCount: Int) {
        self.candidate = candidate
        contentView.backgroundColor = candidate.backgroundColor
        switch candidate.figure {
        case .none:                           figureLabel.text = nil
        case .autoCharacter(let character):   figureLabel.text = String(character)
        case .customCharacter(let character): figureLabel.text = String(character)
        }
        figureLabel.textColor = candidate.color
        figureLabel.backgroundColor = candidate.backgroundColor
        if let text = candidate.text {
            candidateTextLabel.text = text
            candidateTextLabel.textColor = candidate.color
            candidateTextLabel.backgroundColor = candidate.backgroundColor
            stackView.insertArrangedSubview(candidateTextLabel, at: 0)
        } else {
            stackView.removeArrangedSubview(candidateTextLabel)
            candidateTextLabel.removeFromSuperview()
        }
        votesLabel.text = "\(candidateVoteCount)"
        votesLabel.textColor = candidate.color
        votesLabel.backgroundColor = candidate.backgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
