//
//  QuestionReportTableViewCell.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/26/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol QuestionReportTableViewCellDelegate: class {
    var ballot: Ballot? { get }
    func dismissReport()
}

class QuestionReportTableViewCell: UITableViewCell {

    weak var delegate: QuestionReportTableViewCellDelegate?
    @IBOutlet var questionLabel: UILabel!

    func load() {
        guard let ballot = delegate?.ballot else {
            fatalError("Question report cell requires ballot")
        }
        questionLabel.text = ballot.questionText
    }

    @IBAction func dismissButtonPrimaryActionTriggered(_ sender: ArrowButton) {
        delegate?.dismissReport()
    }
}
