//
//  ReportViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

protocol ReportViewControllerDelegate: class {
    func dismissReport(for election: Election, with conversation: MSConversation)
}

class ReportViewController:
    UIViewController,
    MessagesChildViewController,
    ReportTableViewControllerDelegate {

    weak var delegate: ReportViewControllerDelegate!
    var election: Election!
    var conversation: MSConversation!

    override func viewDidLoad() {
        let tableViewController = childViewControllers.first! as! ReportTableViewController
        tableViewController.initConnect(delegate: self, election: election)
        super.viewDidLoad()
    }

    // MARK: ReportViewControllerDelegate methods

    func dismissReport(for election: Election) {
        delegate.dismissReport(for: election, with: conversation)
    }
}
