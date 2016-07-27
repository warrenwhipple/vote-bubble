//
//  BuildViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

protocol BuildViewControllerDelegate: class {
    func aprove(ballot: Ballot, with conversation: MSConversation)
}

class BuildViewController: UIViewController, BuildTableViewControllerDelegate {

    private(set) weak var delegate: BuildViewControllerDelegate!
    private(set) var ballot: Ballot!
    private(set) var conversation: MSConversation!

    func initConnect(delegate: BuildViewControllerDelegate,
                     ballot: Ballot,
                     conversation: MSConversation) {
        self.delegate = delegate
        self.ballot = ballot
        self.conversation = conversation
    }

    override func viewDidLoad() {
        let tableViewController = childViewControllers.first! as! BuildTableViewController
        tableViewController.initConnect(
            delegate: self,
            ballot: ballot,
            conversation: conversation
        )
        super.viewDidLoad()
    }

    // MARK: - BuildTableViewControllerDelegate methods

    func approve(ballot: Ballot, with conversation: MSConversation) {
        delegate.aprove(ballot: ballot, with: conversation)
    }
}
