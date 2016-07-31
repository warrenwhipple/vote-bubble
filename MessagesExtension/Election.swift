//
//  Election.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

class Election {
    var session: MSSession?
    var cloudKitID: UUID?
    enum Status: Int { case open, closed }
    var status: Status
    var voterIDs: [UUID]
    let ballot: Ballot
    var votes: [[Int]]

    init(session: MSSession?,
         cloudKitID: UUID?,
         status: Status,
         voterIDs: [UUID],
         ballot: Ballot,
         votes: [[Int]]) {

        self.session = session
        self.cloudKitID = cloudKitID
        self.status = status
        self.voterIDs = voterIDs
        self.ballot = ballot
        self.votes = votes
    }

    convenience init?(message: MSMessage) {
        guard let url = message.url else { return nil }
        self.init(session: message.session, url: url)
    }

    func didVote(_ voterID: UUID) -> Bool {
        return voterIDs.contains({ $0 == voterID })
    }

    func recordVote(voterID: UUID, candidateIndex: Int) {
        guard !didVote(voterID) else { print("Voter already voted"); return }
        votes[candidateIndex].append(voterIDs.count)
        voterIDs.append(voterID)
    }

    func message(sender: UUID) -> MSMessage {
        let actionText: String
        let summaryText: String
        if session == nil {
            actionText = "$\(sender.uuidString) started a vote."
            if let questionText = ballot.questionText {
                summaryText = "Vote started: \n" + questionText
            } else {
                summaryText = "Vote started"
            }
        } else {
            switch status {
            case .open:
                if sender == voterIDs.last {
                    actionText = "$\(sender.uuidString) voted."
                    summaryText = "Voted"
                } else {
                    actionText = "$\(sender.uuidString) sent a vote."
                    summaryText = "Vote sent"
                }
            case .closed:
                actionText = "$\(sender.uuidString) sent vote results."
                summaryText = "Vote results"
            }
        }
        let layout = MSMessageTemplateLayout()
        layout.image = ballot.messageImage()
        layout.caption = ballot.questionText
        layout.trailingSubcaption = actionText
        let message = MSMessage(session: session ?? MSSession())
        message.summaryText = summaryText
        message.layout = layout
        message.url = url()
        return message
    }
}
