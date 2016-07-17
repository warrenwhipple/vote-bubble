//
//  CandidateVoteView.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/17/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol CandidateVoteViewDelegate {
    func vote(candidate: Candidate)
}

class CandidateVoteView: UIView {

    var delegate: CandidateVoteViewDelegate?
    private(set) var candidate: Candidate?

    func loadCandidate(_ candidate: Candidate) {
        self.candidate = candidate
    }
}
