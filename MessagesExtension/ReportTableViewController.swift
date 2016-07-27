//
//  ReportTableViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/26/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

protocol ReportTableViewControllerDelegate: class {
    func dismissReport(ballot: Ballot, with conversation: MSConversation)
}

class ReportTableViewController:
    UITableViewController,
    CandidateReportTableViewCellDelegate,
    QuestionReportTableViewCellDelegate {

    private(set) weak var delegate: ReportTableViewControllerDelegate!
    private(set) var ballot: Ballot!
    private(set) var conversation: MSConversation!

    func initConnect(delegate: ReportTableViewControllerDelegate,
                     ballot: Ballot,
                     conversation: MSConversation) {
        self.delegate = delegate
        self.ballot = ballot
        self.conversation = conversation
    }

    // MARK: - UITableViewDataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let ballot = ballot else { return 0 }
        return ballot.candidates.count + 1
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < ballot.candidates.count {
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "CandidateReportTableViewCell",
                for: indexPath
                ) as! CandidateReportTableViewCell
            cell.load(delegate: self, candidate: ballot.candidates[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "QuestionReportTableViewCell",
                for: indexPath
                ) as! QuestionReportTableViewCell
            cell.load(delegate: self, ballot: ballot)
            return cell
        }
    }

    // MARK: - ReportTableViewControllerDelegate methods

    func dismissReport(ballot: Ballot) {
        delegate.dismissReport(ballot: ballot, with: conversation)
    }
}
