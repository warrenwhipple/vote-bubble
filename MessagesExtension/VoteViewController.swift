//
//  VoteViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

protocol VoteViewControllerDelegate: class {
    func vote(for candidate: Candidate, on ballot: Ballot, with conversation: MSConversation)
    func declineToVote(on ballot: Ballot, with conversation: MSConversation)
    func dismissVote(on ballot: Ballot, with conversation: MSConversation)
}

class VoteViewController: UIViewController, VoteButtonDelegate {

    @IBOutlet weak var candidatesBrickView: BrickView!
    @IBOutlet weak var questionLabel: UILabel!
    private(set) weak var delegate: VoteViewControllerDelegate!
    private(set) var ballot: Ballot!
    private(set) var conversation: MSConversation!

    func initConnect(delegate: VoteViewControllerDelegate,
                     ballot: Ballot,
                     conversation: MSConversation) {
        self.delegate = delegate
        self.ballot = ballot
        self.conversation = conversation
    }

    override func viewDidLoad() {
        for candidate in ballot.candidates {
            let candidateView = VoteButton(
                frame: CGRect.zero,
                delegate: self,
                candidate: candidate
            )
            candidatesBrickView.addSubview(candidateView)
        }
        if let text = ballot.questionText {
            questionLabel.text = text
        } else {
            questionLabel.removeFromSuperview()
        }
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        candidatesBrickView.updateAspectRatioConstraint()
    }

    @IBAction func backButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.dismissVote(on: ballot, with: conversation)
    }

    @IBAction func declineVoteButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.declineToVote(on: ballot, with: conversation)
    }

    // MARK: - CandidateVoteViewDelegate methods

    func vote(for candidate: Candidate) {
        delegate?.vote(for: candidate, on: ballot, with: conversation)
    }
}
