//
//  CandidateReportTableViewCell.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/26/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol CandidateReportTableViewCellDelegate: class {
    var ballot: Ballot? { get }
}

class CandidateReportTableViewCell: UITableViewCell {

    @IBOutlet var figureLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var candidateTextLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!

    weak var delegate: CandidateReportTableViewCellDelegate?
    private(set) var candidate: Candidate?

    func load(candidate: Candidate) {
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
        var votesText = "\(candidate.votes.count):"
        guard let voterIDs = delegate?.ballot?.voterIDs else {
            fatalError("Candidate report requires ballot")
        }
        var useComma = false
        for vote in candidate.votes {
            guard vote < voterIDs.count else { continue }
            if useComma {
                votesText += ","
            } else {
                useComma = true
            }
            votesText += " $\(voterIDs[vote])"
        }
        votesLabel.text = votesText
        votesLabel.textColor = candidate.color
        votesLabel.backgroundColor = candidate.backgroundColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
