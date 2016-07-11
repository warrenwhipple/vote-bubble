//
//  Ballot.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/8/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

class Ballot {

    enum State { case building, votingUnsent, votingSent, reporting }
    
    var state: State
    var questionText: String?
    var candidates: [Candidate]
    var didVoteVoterIDs: [UUID]

    init(state: State = .building,
         questionText: String? = nil,
         candidates: [Candidate] = [],
         didVoteVoterIDs: [UUID] = []) {
        self.state = state
        self.questionText = questionText
        self.candidates = candidates
        self.didVoteVoterIDs = didVoteVoterIDs
    }

    init(message: MSMessage) {
        // TODO: TODO: Init Ballot from message
        state = .building
        questionText = "Ballot init(message:) incomplete"
        candidates = []
        didVoteVoterIDs = []
    }

    func didVote(_ voterID: UUID) -> Bool {
        return didVoteVoterIDs.contains({ $0 == voterID })
    }

    func isCandidate(_ candidate: Candidate) -> Bool {
        return candidates.contains({ $0 === candidate })
    }

    func recordVote(voterID: UUID, candidate: Candidate) {
        guard !didVote(voterID) else { print("Voter already voted"); return }
        guard isCandidate(candidate) else { print("Not a condidate"); return }
        candidate.votes.append(voterID)
        didVoteVoterIDs.append(voterID)
    }

    func url() -> URL {
        var queryItems: [URLQueryItem] = []
        let stateString: String
        switch state {
        case .building:     stateString = "b"
        case .votingUnsent: stateString = "u"
        case .votingSent:   stateString = "v"
        case .reporting:    stateString = "r"
        }
        queryItems.append(URLQueryItem(name: "s", value: stateString))
        if let questionString = questionText {
            queryItems.append(URLQueryItem(name: "q", value: questionString))
        }
        var components = URLComponents()
        components.queryItems = queryItems
        guard let url = components.url else {
            fatalError("Failed to create URL from ballot components")
        }
        return url
    }

    init?(url: URL) {
        return nil
    }

    func message(sender: UUID) -> MSMessage {
        let actionText: String
        let summaryText: String

        switch state {
        case .building, .votingUnsent:
            actionText = "$\(sender.uuidString) started a vote."
            summaryText = questionText == nil ? actionText : "\(actionText)\n\(questionText)"
        case .votingSent:
            if sender == didVoteVoterIDs.last {
                actionText = "$\(sender.uuidString) voted."
                summaryText = actionText
            } else {
                actionText = "$\(sender.uuidString) sent a vote."
                summaryText = questionText == nil ? actionText : "\(actionText)\n\(questionText)"
            }
        case .reporting:
            actionText = "$\(sender.uuidString) sent vote results."
            summaryText = actionText
        }

        let layout = MSMessageTemplateLayout()
        layout.image = messageImage()
        layout.caption = questionText
        layout.trailingSubcaption = actionText
        let message = MSMessage()
        message.summaryText = summaryText
        message.layout = layout
        return message
    }

    private func messageImage() -> UIImage? {
        let (messageSize, answerRects) = CGRect.stackedRects(
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

    static func simpleYesNo() -> Ballot {
        let yesCandidate = Candidate(
            color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
            backgroundColor: #colorLiteral(red: 0.2818343937, green: 0.5693024397, blue: 0.1281824261, alpha: 1),
            text: "Yes",
            figure: .character("Y")
        )
        let noCandidate = Candidate(
            color: #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
            backgroundColor: #colorLiteral(red: 0.7109192292, green: 0, blue: 0.1382592636, alpha: 1),
            text: "No",
            figure: .character("N")
        )
        return Ballot(
            questionText: "Your opinion please?",
            candidates: [yesCandidate, noCandidate],
            state: .building
        )
    }
}
