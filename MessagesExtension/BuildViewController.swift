//
//  BuildViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BuildViewControllerDelegate: class {
    var ballot: Ballot? { get }
    func aproveBallot()
}

class BuildViewController: UIViewController, BuildTableViewControllerDelegate {

    @IBOutlet var bubbleHeightConstraint: NSLayoutConstraint!
    
    var buildTableViewController: BuildTableViewController?
    weak var delegate: BuildViewControllerDelegate?
    var ballot: Ballot? { return delegate?.ballot }
    var lastQuestionCharacterWasSpace = false

    override func viewDidLoad() {
        super.viewDidLoad()
        for viewController in childViewControllers {
            if let buildTableViewController = viewController as? BuildTableViewController {
                self.buildTableViewController = buildTableViewController
                buildTableViewController.delegate = self
                break
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let tableView = buildTableViewController?.tableView {
            print(tableView.contentSize)
            bubbleHeightConstraint.constant = tableView.contentSize.height
        }
    }

    // MARK: - BuildTableViewControllerDelegate methods

    func approveBallot() {
        delegate?.aproveBallot()
    }

    func tableContentHeightDidChange(height: CGFloat) {
        bubbleHeightConstraint.constant = height
    }
}
