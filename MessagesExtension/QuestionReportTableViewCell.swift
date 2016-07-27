//
//  QuestionReportTableViewCell.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/26/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol QuestionReportTableViewCellDelegate: class {
    func dismissReport(ballot: Ballot)
}

class QuestionReportTableViewCell: UITableViewCell {

    private(set) weak var delegate: QuestionReportTableViewCellDelegate!
    private(set) var ballot: Ballot!
    @IBOutlet var questionLabel: UILabel!

    func load(delegate: QuestionReportTableViewCellDelegate,
              ballot: Ballot) {
        self.delegate = delegate
        self.ballot = ballot
        questionLabel.text = ballot.questionText
    }

    @IBAction func dismissButtonPrimaryActionTriggered(_ sender: ArrowButton) {
        delegate.dismissReport(ballot: ballot)
    }
}
