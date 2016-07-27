//
//  ReportTableViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/26/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol ReportTableViewControllerDelegate: class {
    var ballot: Ballot? { get }
    func dismissReport()
}

class ReportTableViewController:
    UITableViewController,
    CandidateReportTableViewCellDelegate,
    QuestionReportTableViewCellDelegate {

    weak var delegate: ReportTableViewControllerDelegate? {
        didSet {
            if ballot != nil {
                tableView?.reloadData()
            }
        }
    }

    var ballot: Ballot? {
        return delegate?.ballot
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
        guard let ballot = ballot else {
            fatalError("Candidate report requires ballot")
        }
        if indexPath.row < ballot.candidates.count {
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "CandidateReportTableViewCell",
                for: indexPath
                ) as! CandidateReportTableViewCell
            cell.delegate = self
            cell.load(candidate: ballot.candidates[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "QuestionReportTableViewCell",
                for: indexPath
                ) as! QuestionReportTableViewCell
            cell.delegate = self
            cell.load()
            return cell
        }
    }

    // MARK: - ReportTableViewControllerDelegate methods

    func dismissReport() {
        delegate?.dismissReport()
    }
}
