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

class ReportViewController: UIViewController, ReportTableViewControllerDelegate {

    private(set) weak var delegate: ReportViewControllerDelegate!
    private(set) var ballot: Ballot!
    private(set) var conversation: MSConversation!

    func initConnect(delegate: ReportViewControllerDelegate,
                     ballot: Ballot,
                     conversation: MSConversation) {
        self.delegate = delegate
        self.ballot = ballot
        self.conversation = conversation
    }

    override func viewDidLoad() {
        let tableViewController = childViewControllers.first! as! ReportTableViewController
        tableViewController.initConnect(
            delegate: self,
            ballot: ballot, conversation: conversation
        )
        super.viewDidLoad()
    }

    // MARK: ReportViewControllerDelegate methods

    func dismissReport(ballot: Ballot, with conversation: MSConversation) {
        delegate.dismissReport(ballot: ballot, with: conversation)
    }
}
