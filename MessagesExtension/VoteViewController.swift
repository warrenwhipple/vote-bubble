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

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var candidatesBrickView: BrickView!
    @IBOutlet weak var candidatesBrickViewAspectRationConstraint: NSLayoutConstraint!

    weak var delegate: VoteViewControllerDelegate?

    override func viewDidLoad() {
        //candidatesBrickView.aspectRatioConstraint = candidatesBrickViewAspectRationConstraint
        guard let ballot = delegate?.ballot else { return }
        for candidate in ballot.candidates {
            /*
            guard let candidateView =
                candidateCharacterTextPrototypeView.copy() as? CandidateCharacterTextVoteView
            else { continue }
            candidateView.loadCandidate(candidate)
            candidatesBrickView.addSubview(candidateView)
            */
        }
    }

    @IBAction func backButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.cancelVote()
    }

    @IBAction func declineVoteButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.declineToVote()
    }

}
