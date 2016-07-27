//
//  ReportViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

protocol ReportViewControllerDelegate: class {
    func dismissReport(ballot: Ballot, with conversation: MSConversation)
}

class ReportViewController:
    UIViewController,
    MessagesChildViewController,
    ReportTableViewControllerDelegate {

    weak var delegate: ReportViewControllerDelegate!
    var ballot: Ballot!
    var conversation: MSConversation!

    override func viewDidLoad() {
        let tableViewController = childViewControllers.first! as! ReportTableViewController
        tableViewController.initConnect(delegate: self, ballot: ballot)
        super.viewDidLoad()
    }

    // MARK: ReportViewControllerDelegate methods

    func dismissReport(ballot: Ballot) {
        delegate.dismissReport(ballot: ballot, with: conversation)
    }
}
