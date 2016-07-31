//
//  QuestionReportTableViewCell.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/26/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol QuestionReportTableViewCellDelegate: class {
    func dismissReport(for election: Election)
}

class QuestionReportTableViewCell: UITableViewCell {

    private(set) weak var delegate: QuestionReportTableViewCellDelegate!
    private(set) var election: Election!
    @IBOutlet var questionLabel: UILabel!

    func load(delegate: QuestionReportTableViewCellDelegate,
              election: Election) {
        self.delegate = delegate
        self.election = election
        questionLabel.text = election.ballot.questionText
    }

    @IBAction func dismissButtonPrimaryActionTriggered(_ sender: ArrowButton) {
        delegate.dismissReport(for: election)
    }
}
