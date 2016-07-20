//
//  VoteBubbleTests.swift
//  VoteBubbleTests
//
//  Created by Warren Whipple on 7/19/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import XCTest

class VoteBubbleTests: XCTestCase {
    
    func testExample() {
        let voterIDs = [UUID(),UUID(),UUID(),UUID()]
        let ballot = Ballot.init(
            state: .votingSent,
            questionText: "What's the deal yo?",
            candidates: [
                Candidate(
                    color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
                    backgroundColor: #colorLiteral(red: 0.7540004253, green: 0, blue: 0.2649998069, alpha: 1),
                    text: "It's all over man",
                    figure: Figure.autoCharacter("😱"),
                    votes: [0,3]
                ),
                Candidate(
                    color: #colorLiteral(red: 0.1142767668, green: 0.3181744218, blue: 0.4912756383, alpha: 1),
                    backgroundColor: #colorLiteral(red: 0.7602152824, green: 0.7601925135, blue: 0.7602053881, alpha: 1),
                    text: "It's totes sweets",
                    figure: Figure.autoCharacter("😍"),
                    votes: [1,2]
                )
            ],
            voterIDs: voterIDs
        )
        let ballotCopy = Ballot(url: ballot.url())
        XCTAssert(ballot.url() == ballotCopy?.url())
    }
}
