//
//  VoteViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

protocol VoteViewControllerDelegate: class {
    func vote(for candidateIndex: Int, in election: Election, with conversation: MSConversation)
    func declineToVote(in election: Election, with conversation: MSConversation)
    func dismissVote(in election: Election, with conversation: MSConversation)
}

class VoteViewController:
    UIViewController,
    MessagesChildViewController,
    VoteButtonDelegate {

    @IBOutlet weak var candidatesBrickView: BrickView!
    @IBOutlet weak var questionLabel: UILabel!
    weak var delegate: VoteViewControllerDelegate!
    var election: Election!
    var conversation: MSConversation!

    override func viewDidLoad() {
        for (i, candidate) in election.ballot.candidates.enumerated() {
            let candidateView = VoteButton(
                frame: CGRect.zero,
                delegate: self,
                candidate: candidate,
                candidateIndex: i
            )
            candidatesBrickView.addSubview(candidateView)
        }
        if let text = election.ballot.questionText {
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
        delegate?.dismissVote(in: election, with: conversation)
    }

    @IBAction func declineVoteButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.declineToVote(in: election, with: conversation)
    }

    // MARK: - CandidateVoteViewDelegate methods

    func vote(for candidateIndex: Int) {
        delegate?.vote(for: candidateIndex, in: election, with: conversation)
    }
}
