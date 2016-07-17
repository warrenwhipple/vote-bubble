//
//  VoteViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit
import Messages

protocol VoteViewControllerDelegate: class {
    var ballot: Ballot? { get }
    func vote(candidate: Candidate)
    func declineToVote()
    func cancelVote()
}

class VoteViewController: UIViewController {

    @IBOutlet weak var candidatesView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    weak var delegate: VoteViewControllerDelegate?

    @IBAction func backButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.cancelVote()
    }

    @IBAction func declineVoteButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.declineToVote()
    }

}
