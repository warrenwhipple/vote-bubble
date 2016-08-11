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
    var cloudKitRecordID: UUID
    var encryptionKey: EncryptionKey
    enum Status: Int { case open, closed }
    var status: Status
    let ballot: Ballot
    var voters: [Voter]
    var votes: [[Int]]

    init() {
        session = nil
        cloudKitRecordID = UUID()
        encryptionKey = EncryptionKey()
        status = .open
        ballot = Ballot()
        voters = []
        votes = []
    }

    init(ballot: Ballot) {
        session = nil
        cloudKitRecordID = UUID()
        encryptionKey = EncryptionKey()
        status = .open
        self.ballot = ballot
        voters = []
        votes = []
    }

    init?(message: MSMessage) {
        guard let session = message.session else {
            print("Message has no session")
            return nil
        }
        self.session = session

        guard let url = message.url else {
            print("Message has no URL")
            return nil
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("Failed to get URL components from URL: \(url.relativeString)")
            return nil
        }
        guard let queryItems = components.queryItems else {
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
        var candidateColor: UIColor?

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
            case "c": candidateColor = UIColor(hexString: value)
            case "b":
                if  let candidateColor = candidateColor,
                    let candidateBackgroundColor = UIColor(hexString: value) {
                    candidates.append(Candidate(
                        text: candidateText,
                        figure: candidateFigure ?? .none,
                        color: candidateColor,
                        backgroundColor: candidateBackgroundColor)
                    )
                }
                candidateText = nil
                candidateFigure = nil
                candidateColor = nil
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
                print("Unrecognized URL query item found")
            }
        }
        guard let foundCloudKitRecordID = cloudKitRecordID else {
            print("URL contained no CloudKit record ID")
            return nil
        }
        self.cloudKitRecordID = foundCloudKitRecordID
        guard let foundEncryptionKey = encryptionKey else {
            print("URL contained no encryption key")
            return nil
        }
        self.encryptionKey = foundEncryptionKey
        self.status = status ?? .open
        ballot = Ballot(
            questionText: ballotQuestionText,
            candidates: candidates
        )
        self.voters = voters
        self.votes = votes ?? []
    }

    func didVote(_ voter: Voter) -> Bool {
        for didVoteVoter in voters {
            if voter.cloudKitUserID == didVoteVoter.cloudKitUserID {
                return true
            }
        }
        return false
    }

    func recordVote(voter: Voter, candidateIndex: Int) {
        guard !didVote(voter) else { print("Voter already voted"); return }
        votes[candidateIndex].append(voters.count)
        voters.append(voter)
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
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "r", value: cloudKitRecordID.base64EncodedForURLString),
            URLQueryItem(name: "k", value: encryptionKey.base64EncodedForURLString)
        ] + coreQueryItems()
        message.url = urlComponents.url
        return message
    }

    func updateWith(oldVoteData: Data, newVoteData: Data) {

    }

    func voteData() -> Data {
        // TODO: Add data method
        return Data()
    }

    private func coreQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        func add(_ name: String, _ value: String?) {
            guard let value = value , !value.isEmpty else { return }
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        if status == .closed {
            add("s", "c")
        }

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
            add("c", candidate.color.hexString())
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
        
        return queryItems
    }
}
