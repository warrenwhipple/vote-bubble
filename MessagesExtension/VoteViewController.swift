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

class VoteViewController: UIViewController, CandidateVoteViewDelegate {

    @IBOutlet weak var candidatesBrickView: BrickView!
    weak var delegate: VoteViewControllerDelegate?

    override func viewDidLoad() {
        guard let ballot = delegate?.ballot else { return }
        for candidate in ballot.candidates {
            let candidateView = CandidateVoteView(candidate: candidate)
            candidateView.delegate = self
            candidatesBrickView.addSubview(candidateView)
        }
    }

    override func viewWillLayoutSubviews() {
        candidatesBrickView.updateAspectRatioConstraint()
    }

    override func viewDidLayoutSubviews() {
        candidatesBrickView.arrangeSubviewsAsBricks(containerWidth: candidatesBrickView.frame.width)
    }

    @IBAction func backButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.cancelVote()
    }

    @IBAction func declineVoteButtonPrimaryActionTriggered(_ sender: UIButton) {
        delegate?.declineToVote()
    }

    // MARK: - CandidateVoteViewDelegate methods

    func vote(candidate: Candidate) {
        delegate?.vote(candidate: candidate)
    }
}
