//
//  ReportViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol ReportViewControllerDelegate: class {
    var ballot: Ballot? { get }
    func dismissReport()
}

class ReportViewController: UIViewController, ReportTableViewControllerDelegate {

    weak var delegate: ReportViewControllerDelegate? {
        didSet {
            if ballot != nil {
                tableViewController?.tableView?.reloadData()
            }
        }
    }

    var ballot: Ballot? {
        return delegate?.ballot
    }

    var tableViewController: ReportTableViewController? {
        return childViewControllers.first as? ReportTableViewController
    }

    override func viewDidLoad() {
        tableViewController?.delegate = self
        super.viewDidLoad()
    }

    // MARK: ReportViewControllerDelegate methods

    func dismissReport() {
        delegate?.dismissReport()
    }
}
