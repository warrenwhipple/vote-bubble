//
//  BuildTableViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BuildTableViewControllerDelegate: class {
    func approve(ballot: Ballot)
}

class BuildTableViewController:
    UITableViewController,
    CandidateBuildTableViewCellDelegate,
    QuestionBuildTableViewCellDelegate {

    private(set) weak var delegate: BuildTableViewControllerDelegate!
    private(set) var ballot: Ballot!

    func initConnect(delegate: BuildTableViewControllerDelegate, ballot: Ballot) {
        self.delegate = delegate
        self.ballot = ballot
    }
    
    // MARK: - UITableViewDataSource methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return ballot.candidates.count + 2
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= ballot.candidates.count {
            let cell = tableView.dequeueReusableCell (
                withIdentifier: "CandidateBuildTableViewCell",
                for: indexPath
            ) as! CandidateBuildTableViewCell
            if indexPath.row < ballot.candidates.count {
                cell.load(delegate: self, candidate: ballot.candidates[indexPath.row])
            } else {
                cell.load(delegate: self, candidate: nil)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "QuestionBuildTableViewCell",
                for: indexPath
                ) as! QuestionBuildTableViewCell
            cell.load(delegate: self, ballot: ballot)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < ballot.candidates.count
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ballot.candidates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // MARK: - CandidateBuildTableViewCellDelegate methods

    func newCandidate() -> Candidate {
        let candidate = Candidate(
            color: UIColor.white,
            backgroundColor: UIColor.randomHue(),
            text: nil,
            figure: .none
        )
        ballot.candidates.append(candidate)
        let indexPath = IndexPath(item: ballot.candidates.count , section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        return candidate
    }

    // MARK: - QuestionBuildTableViewCellDelegate methods

    func approve(ballot: Ballot) {
        delegate.approve(ballot: ballot)
    }
}
