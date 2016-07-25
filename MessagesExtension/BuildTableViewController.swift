//
//  BuildTableViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BuildTableViewControllerDelegate: class {
    var ballot: Ballot? { get }
    func approveBallot()
}

class BuildTableViewController:
    UITableViewController,
    CandidateBuildTableViewCellDelegate,
    QuestionBuildTableViewCellDelegate {

    weak var delegate: BuildTableViewControllerDelegate? {
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
        return ballot.candidates.count + 2
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let candidateCount = ballot?.candidates.count ?? 0
        if indexPath.row <= candidateCount {
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "CandidateBuildTableViewCell",
                for: indexPath
            ) as! CandidateBuildTableViewCell
            cell.delegate = self
            if indexPath.row < candidateCount {
                cell.loadCandidate(ballot?.candidates[indexPath.row])
            } else {
                cell.loadCandidate(nil)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "QuestionBuildTableViewCell",
                for: indexPath
                ) as! QuestionBuildTableViewCell
            cell.delegate = self
            cell.load()
            return cell
        }
    }

    override func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        guard let ballot = ballot else { return false }
        return indexPath.row < ballot.candidates.count
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard let ballot = ballot else { return }
        guard let tableView = view as? UITableView else { return }
        if editingStyle == .delete {
            ballot.candidates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - CandidateBuildTableViewCellDelegate methods

    func newCandidate() -> Candidate {
        let candidate = Candidate(color: UIColor.white(), backgroundColor: UIColor.randomHue())
        guard let ballot = ballot else { fatalError("New candidate requires ballot") }
        guard let tableView = view as? UITableView else { fatalError("View must be UITableView") }
        ballot.candidates.append(candidate)
        let indexPath = IndexPath(item: ballot.candidates.count , section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        return candidate
    }

    // MARK: - QuestionBuildTableViewCellDelegate methods

    func approveBallot() {
        delegate?.approveBallot()
    }
}
