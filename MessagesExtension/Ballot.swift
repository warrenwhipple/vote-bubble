//
//  Ballot.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/8/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

class Ballot {

    var session: MSSession?
    var cloudKitID: UUID?
    enum Status: Int { case open, closed }
    var status: Status
    var questionText: String?
    var candidates: [Candidate]
    var voterIDs: [UUID]

    init(session: MSSession?,
         cloudKitID: UUID?,
         status: Status,
         questionText: String?,
         candidates: [Candidate],
         voterIDs: [UUID]) {
        self.session = session
        self.cloudKitID = cloudKitID
        self.status = status
        self.questionText = questionText
        self.candidates = candidates
        self.voterIDs = voterIDs
    }

    convenience init?(message: MSMessage) {
        guard let url = message.url else { return nil }
        self.init(session: message.session, url: url)
    }

    func didVote(_ voterID: UUID) -> Bool {
        return voterIDs.contains({ $0 == voterID })
    }

    func isCandidate(_ candidate: Candidate) -> Bool {
        return candidates.contains({ $0 === candidate })
    }

    func recordVote(voterID: UUID, candidate: Candidate) {
        guard !didVote(voterID) else { print("Voter already voted"); return }
        guard isCandidate(candidate) else { print("Not a candidate"); return }
        candidate.votes.append(voterIDs.count)
        voterIDs.append(voterID)
    }

    func message(sender: UUID) -> MSMessage {
        let actionText: String
        let summaryText: String
        if session == nil {
            actionText = "$\(sender.uuidString) started a vote."
            if let questionText = questionText {
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
        layout.image = messageImage()
        layout.caption = questionText
        layout.trailingSubcaption = actionText
        let message = MSMessage(session: session ?? MSSession())
        message.summaryText = summaryText
        message.layout = layout
        message.url = url()
        return message
    }

    private func messageImage() -> UIImage? {
        let (messageSize, answerRects) = CGRect.bricks(
            containerWidth: MSMessageTemplateLayout.defaultWidth,
            count: candidates.count
        )
        let scale = MSMessageTemplateLayout.defaultScale
        let opaque = true
        UIGraphicsBeginImageContextWithOptions(messageSize, opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to create graphics context")
            return nil
        }
        for (answer, rect) in zip(candidates, answerRects) {
            answer.draw(context: context, rect: rect)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Failed to get image from image context")
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }

    static func new() -> Ballot {
        return Ballot(
            session: nil,
            cloudKitID: nil,
            status: .open,
            questionText: nil,
            candidates: [],
            voterIDs: []
        )
    }
}
