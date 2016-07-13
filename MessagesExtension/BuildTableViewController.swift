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
}

class BuildTableViewController: UITableViewController {

    var delegate: BuildTableViewControllerDelegate?

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return (delegate?.ballot?.candidates.count ?? 0) + 2
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let candidateCount = delegate?.ballot?.candidates.count ?? 0
        if indexPath.row == candidateCount {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "AddBuildTableViewCell",
                for: indexPath
                ) as! AddBuildTableViewCell
            return cell
        } else if indexPath.row == candidateCount + 1 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "QuestionBuildTableViewCell",
                for: indexPath
                ) as! QuestionBuildTableViewCell
            cell.textField.text = delegate?.ballot?.questionText
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CandidateBuildTableViewCell",
                for: indexPath
            ) as! CandidateBuildTableViewCell
            guard let candidate = delegate?.ballot?.candidates[indexPath.row] else { return cell }
            cell.candidate = candidate
            cell.textField.text = candidate.text
            cell.contentView.backgroundColor = candidate.backgroundColor
            cell.textField.textColor = candidate.color
            cell.textField.layer.borderColor = candidate.color.cgColor
            return cell
        }
    }
}
