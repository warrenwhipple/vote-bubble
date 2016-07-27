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

class BuildViewController:
    UIViewController,
    MessagesChildViewController,
    BuildTableViewControllerDelegate {

    weak var delegate: BuildViewControllerDelegate!
    var ballot: Ballot!
    var conversation: MSConversation!

    override func viewDidLoad() {
        let tableViewController = childViewControllers.first! as! BuildTableViewController
        tableViewController.initConnect(delegate: self, ballot: ballot)
        super.viewDidLoad()
    }

    // MARK: - BuildTableViewControllerDelegate methods

    func approve(ballot: Ballot) {
        delegate.aprove(ballot: ballot, with: conversation)
    }
}
