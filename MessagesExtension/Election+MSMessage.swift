//
//  Election+MSMessage.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

extension Election {

    convenience init?(message: MSMessage) {

        guard let session = message.session else {
            print("Message has no session")
            return nil
        }

        guard let url = message.url else {
            print("Message has no URL")
            return nil
        }

        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("Failed to get URL components from URL: \(url.relativeString)")
            return nil
        }

        guard let queryItems = urlComponents.queryItems else {
            print("Failed to get URL query items from URL components: \(url.relativeString)")
            return nil
        }

        var cloudKitRecordID: UUID?
        var encryptionKey: EncryptionKey?
        var status: Status?
        var ballotQuestionText: String?

        var candidates: [Candidate] = []
        var candidateText: String?
        var candidateFigure: Figure?
        var candidateTextColor: UIColor?

        var voters: [Voter] = []
        var voterName: String?
        var voterMark: String?

        var votes: [[Int]]?

        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }

            switch queryItem.name {
            case "r": cloudKitRecordID = UUID(base64EncodedForURL: value)
            case "k": encryptionKey = EncryptionKey(base64EncodedForURL: value)
            case "s": if value == "c" { status = .closed }
            case "q": ballotQuestionText = value
            case "t": candidateText = value
            case "fa": candidateFigure = .autoCharacter(value.characters.first ?? " ")
            case "fc": candidateFigure = .customCharacter(value.characters.first ?? " ")
            case "c": candidateTextColor = UIColor(hexString: value)
            case "b":
                if  let candidateTextColor = candidateTextColor,
                    let candidateBackgroundColor = UIColor(hexString: value) {
                    candidates.append(Candidate(
                        text: candidateText,
                        figure: candidateFigure ?? .none,
                        textColor: candidateTextColor,
                        backgroundColor: candidateBackgroundColor)
                    )
                }
                candidateText = nil
                candidateFigure = nil
                candidateTextColor = nil
            case "n": voterName = value
            case "m": voterMark = value
            case "u":
                if let voterCloudKitUserID = UUID(base64EncodedForURL: value) {
                    voters.append(Voter(
                        name: voterName,
                        mark: voterMark,
                        cloudKitUserID: voterCloudKitUserID)
                    )
                }
                voterName = nil
                voterMark = nil
            case "v":
                let voteSentences = value.components(separatedBy: ";")
                let voteWords = voteSentences.map() { $0.components(separatedBy: ",") }
                votes = voteWords.map { $0.flatMap() { Int($0) } }
            default:
                print("Unrecognized URL query item found: \(queryItem.name)")
            }
        }

        guard let foundCloudKitRecordID = cloudKitRecordID else {
            print("URL contained no CloudKit record ID")
            return nil
        }

        guard let foundEncryptionKey = encryptionKey else {
            print("URL contained no encryption key")
            return nil
        }

        let ballot = Ballot(
            questionText: ballotQuestionText,
            candidates: candidates
        )

        self.init(
            session: session,
            cloudKitRecordID: foundCloudKitRecordID,
            encryptionKey: foundEncryptionKey,
            status: status ?? .open,
            ballot: ballot,
            voters: voters,
            votes: votes ?? []
        )
    }

    func message(sender: Voter) -> MSMessage {
        let actionText: String
        let summaryText: String
        if session == nil {
            actionText = "$\(sender.name) started a vote."
            if let questionText = ballot.questionText {
                summaryText = "Vote started: \n" + questionText
            } else {
                summaryText = "Vote started"
            }
        } else {
            switch status {
            case .open:
                if sender.cloudKitUserID == voters.last?.cloudKitUserID {
                    actionText = "$\(sender.name) voted."
                    summaryText = actionText
                } else {
                    actionText = "$\(sender.name) sent a vote."
                    summaryText = actionText
                }
            case .closed:
                actionText = "$\(sender.name) sent vote results."
                summaryText = actionText
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

    func url() -> URL {
        var queryItems: [URLQueryItem] = []

        func add(_ name: String, _ value: String?) {
            guard let value = value , !value.isEmpty else { return }
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        add("r", cloudKitRecordID.base64EncodedForURLString)
        add("k", encryptionKey.base64EncodedForURLString)
        if status == .closed { add("s", "c") }
        add("q", ballot.questionText)

        for candidate in ballot.candidates {
            if let text = candidate.text {
                add("t", text)
            }
            switch candidate.figure {
            case .none: break
            case .autoCharacter(let character):   add("fa", String(character))
            case .customCharacter(let character): add("fc", String(character))
            }
            add("c", candidate.textColor.hexString())
            add("b", candidate.backgroundColor.hexString())
        }

        for voter in voters {
            add("n", voter.name)
            add("m", voter.mark)
            add("u", voter.cloudKitUserID.base64EncodedForURLString)
        }

        let voteWords = votes.map { $0.map() { $0.description } }
        let voteSentences = voteWords.map() { $0.joined(separator: ",") }
        let voteParagraph = voteSentences.joined(separator: ";")
        add("v", voteParagraph)

        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            fatalError("Failed to create URL from URL components")
        }
        return url
    }
    
}
