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
    func didVote(voter: UUID, ballot: Ballot)
    func didDeclineToVote(decliner: UUID, ballot: Ballot)
    func didCancelVote(ballot: Ballot)
    var activeConversation: MSConversation? { get }
}

class VoteViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    weak var delegate: VoteViewControllerDelegate!
    private(set) var ballot: Ballot!

    var localParticipantIdentifier: UUID {
        guard let conversation = delegate.activeConversation else {
            fatalError("Active conversation not found")
        }
        return conversation.localParticipantIdentifier
    }

    func loadBallot(_ ballot: Ballot) {
        self.ballot = ballot
    }

    @IBAction func voteYesPressed(_ sender: AnyObject) {
        ballot.recordVote(voterID: localParticipantIdentifier, candidate: ballot.candidates[0])
        delegate.didVote(voter: localParticipantIdentifier, ballot: ballot)
    }

    @IBAction func voteNoPressed(_ sender: AnyObject) {
        ballot.recordVote(voterID: localParticipantIdentifier, candidate: ballot.candidates[1])
        delegate.didVote(voter: localParticipantIdentifier, ballot: ballot)
    }
}
