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
    var activeConversation: MSConversation? { get }
    func didVote(voter: UUID)
    func didDeclineToVote(decliner: UUID)
    func didCancelVote()
}

class VoteViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    weak var delegate: VoteViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = delegate?.ballot?.questionText
    }

    @IBAction func voteYesPressed(_ sender: AnyObject) {
        guard let ballot = delegate?.ballot,
            let localParticipantIdentifier =
                delegate?.activeConversation?.localParticipantIdentifier else { return }
        ballot.recordVote(voterID: localParticipantIdentifier, candidate: ballot.candidates[0])
        delegate?.didVote(voter: localParticipantIdentifier)
    }

    @IBAction func voteNoPressed(_ sender: AnyObject) {
        guard let ballot = delegate?.ballot,
            let localParticipantIdentifier =
            delegate?.activeConversation?.localParticipantIdentifier else { return }
        ballot.recordVote(voterID: localParticipantIdentifier, candidate: ballot.candidates[1])
        delegate?.didVote(voter: localParticipantIdentifier)
    }
}
