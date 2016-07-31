//
//  DefaultBallots.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/30/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation

let defaultBallots = [
    Ballot(
        session: nil,
        cloudKitID: nil,
        status: .open,
        questionText: nil,
        candidates: [
            Candidate(
                color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
                backgroundColor: #colorLiteral(red: 0.2818343937, green: 0.5693024397, blue: 0.1281824261, alpha: 1),
                text: nil,
                figure: .customCharacter("Y"),
                votes: []
            ),
            Candidate(
                color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
                backgroundColor: #colorLiteral(red: 0.8949507475, green: 0.1438436359, blue: 0.08480125666, alpha: 1),
                text: nil,
                figure: .customCharacter("N"),
                votes: []
            )
        ],
        voterIDs: []
    ),
    Ballot(
        session: nil,
        cloudKitID: nil,
        status: .open,
        questionText: "feeling?",
        candidates: [
            Candidate(
                color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
                backgroundColor: #colorLiteral(red: 0.6707916856, green: 0.8720328808, blue: 0.5221258998, alpha: 1),
                text: nil,
                figure: .customCharacter("😀"),
                votes: []
            ),
            Candidate(
                color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
                backgroundColor: #colorLiteral(red: 0.9385069609, green: 0.5891591311, blue: 0.4726046324, alpha: 1),
                text: nil,
                figure: .customCharacter("😐"),
                votes: []
            ),
            Candidate(
                color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
                backgroundColor: #colorLiteral(red: 0.4120420814, green: 0.8022739887, blue: 0.9693969488, alpha: 1),
                text: nil,
                figure: .customCharacter("😞"),
                votes: []
            ),
            Candidate(
                color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
                backgroundColor: #colorLiteral(red: 0.8779790998, green: 0.3812967837, blue: 0.5770481825, alpha: 1),
                text: nil,
                figure: .customCharacter("😡"),
                votes: []
            )
        ],
        voterIDs: []
    )
]
