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

    weak var delegate: BuildViewControllerDelegate? {
        didSet {
            if ballot != nil {
                buildTableViewController?.tableView?.reloadData()
            }
        }
    }

    var ballot: Ballot? {
        return delegate?.ballot
    }
    
    var buildTableViewController: BuildTableViewController? {
        return childViewControllers.first as? BuildTableViewController
    }

    override func viewDidLoad() {
        buildTableViewController?.delegate = self
        super.viewDidLoad()
    }

    // MARK: - BuildTableViewControllerDelegate methods

    func approveBallot() {
        delegate?.aproveBallot()
    }
}
