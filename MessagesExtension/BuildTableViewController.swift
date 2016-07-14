//
//  BuildTableViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BuildTableViewControllerDelegate {
    var ballot: Ballot? { get }
    func didApproveBallot()
}

class BuildTableViewController:
    UITableViewController,
    CandidateBuildTableViewCellDelegate,
    QuestionBuildTableViewCellDelegate {

    var delegate: BuildTableViewControllerDelegate?
    var ballot: Ballot? { return delegate?.ballot }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = view as? UITableView else { return }
        view.keyboardDismissMode = .interactive
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return (delegate?.ballot?.candidates.count ?? 0) + 2
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

    // MARK: - CandidateBuildTableViewCellDelegate methods

    func newCandidate() -> Candidate {
        let candidate = Candidate(color: UIColor.white(), backgroundColor: UIColor.randomHue())
        guard let ballot = ballot else { fatalError("New candidate require ballot") }
        guard let tableView = view as? UITableView else { fatalError("View must be UITableView") }
        ballot.candidates.append(candidate)
        let indexPath = IndexPath(item: ballot.candidates.count , section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        return candidate
    }

    // MARK: - QuestionBuildTableViewCellDelegate methods

    func didApproveBallot() {
        delegate?.didApproveBallot()
    }

}
