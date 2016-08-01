//
//  Election+url.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

extension Election {

    convenience init?(session: MSSession?, url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("Failed to get URL components from URL: \(url.relativeString)")
            return nil
        }
        guard let queryItems = components.queryItems else {
            print("Failed to get URL query items from URL components: \(url.relativeString)")
            return nil
        }

        var cloudKitID: UUID?
        var status: Status?
        var voterIDs: [UUID]?
        var ballotQuestionText: String?

        var candidates: [Candidate] = []
        var newCandidateDidBegin = false
        var candidateColor: UIColor?
        var candidateBackgroundColor: UIColor?
        var candidateText: String?
        var candidateFigure: Figure?

        var votes: [[Int]]?

        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }

            switch queryItem.name {
            case "i":
                cloudKitID = UUID(base64String: value)
            case "s":
                if value == "c" { status = .closed }
            case "u":
                let voterIDComponents = value.components(separatedBy: ",")
                voterIDs = voterIDComponents.flatMap { UUID(base64String: $0) }
            case "q":
                ballotQuestionText = value
            case "c":
                if newCandidateDidBegin {
                    // Save last candidate values and reset them
                    let candidate = Candidate(
                        color: candidateColor ?? #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1),
                        backgroundColor: candidateBackgroundColor ?? #colorLiteral(red: 0.4266758859, green: 0.4266631007, blue: 0.4266703427, alpha: 1),
                        text: candidateText,
                        figure: candidateFigure ?? .none
                    )
                    candidates.append(candidate)
                    candidateColor = nil
                    candidateBackgroundColor = nil
                    candidateText = nil
                    candidateFigure = nil
                    newCandidateDidBegin = true
                }
                candidateColor = UIColor(hexString: value)
            case "b":
                candidateColor = UIColor(hexString: value)
            case "t":
                candidateText = value
            case "fa":
                candidateFigure = .autoCharacter(value.characters.first ?? " ")
            case "fc":
                candidateFigure = .customCharacter(value.characters.first ?? " ")
            case "v":
                let voteSentences = value.components(separatedBy: ";")
                let voteWords = voteSentences.map() { $0.components(separatedBy: ",") }
                votes = voteWords.map { $0.flatMap() { Int($0) } }
            default:
                print("Unrecognized URL query item found")
            }
        }
        self.init(
            session: session,
            cloudKitID: cloudKitID,
            status: status ?? .open,
            voterIDs: voterIDs ?? [],
            ballot: Ballot(questionText: ballotQuestionText, candidates: candidates),
            votes: votes ?? []
        )
    }

    func url() -> URL {
        var queryItems: [URLQueryItem] = []

        func add(_ name: String, _ value: String?) {
            guard let value = value , !value.isEmpty else { return }
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        if let cloudKitID = cloudKitID {
            add("i", cloudKitID.base64String)
        }

        if status == .closed {
            add("s", "c")
        }

        let voterIDStrings = voterIDs.map { $0.base64String }
        let voterIDJoinedString = voterIDStrings.joined(separator: ",")
        add("u", voterIDJoinedString)

        add("q", ballot.questionText)

        for candidate in ballot.candidates {
            add("c", candidate.color.hexString())
            add("b", candidate.backgroundColor.hexString())
            if let text = candidate.text {
                add("t", text)
            }
            switch candidate.figure {
            case .none: break
            case .autoCharacter(let character):   add("fa", String(character))
            case .customCharacter(let character): add("fc", String(character))
            }
        }

        let voteWords = votes.map { $0.map() { $0.description } }
        let voteSentences = voteWords.map() { $0.joined(separator: ",") }
        let voteParagraph = voteSentences.joined(separator: ";")
        add("v", voteParagraph)

        var components = URLComponents()
        components.queryItems = queryItems
        guard let url = components.url else {
            fatalError("Failed to create URL from ballot components")
        }
        return url
    }
}
