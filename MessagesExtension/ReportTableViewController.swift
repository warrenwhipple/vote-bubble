//
//  ReportTableViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/26/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol ReportTableViewControllerDelegate: class {
    func dismissReport(for election: Election)
}

class ReportTableViewController:
    UITableViewController,
    CandidateReportTableViewCellDelegate,
    QuestionReportTableViewCellDelegate {

    private(set) weak var delegate: ReportTableViewControllerDelegate!
    private(set) var election: Election!

    func initConnect(delegate: ReportTableViewControllerDelegate, election: Election) {
        self.delegate = delegate
        self.election = election
    }

    // MARK: - UITableViewDataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let election = election else { return 0 }
        return election.ballot.candidates.count + 1
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < election.ballot.candidates.count {
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "CandidateReportTableViewCell",
                for: indexPath
                ) as! CandidateReportTableViewCell
            cell.load(
                delegate: self,
                candidate: election.ballot.candidates[indexPath.row],
                candidateVoteCount: election.votes[indexPath.row].count
            )
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "QuestionReportTableViewCell",
                for: indexPath
                ) as! QuestionReportTableViewCell
            cell.load(delegate: self, election: election)
            return cell
        }
    }

    // MARK: - ReportTableViewControllerDelegate methods

    func dismissReport(for: Election) {
        delegate.dismissReport(for: election)
    }
}
