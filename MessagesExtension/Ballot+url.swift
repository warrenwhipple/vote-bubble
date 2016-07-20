//
//  Ballot+url.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/19/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

private let uuidStringLength = UUID().uuidString.characters.count

extension Ballot {

    func url() -> URL {
        var queryItems: [URLQueryItem] = []

        func add(_ name: String, _ value: String?) {
            guard let value = value , !value.isEmpty else { return }
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        add("s", state.rawValue.description)

        add("q", questionText)

        let voterIDWords = voterIDs.map { $0.uuidString }
        let voterIDString = voterIDWords.joined(separator: ",")
        add("u", voterIDString)

        for candidate in candidates {
            add("c", candidate.color.hexString())

            add("b", candidate.backgroundColor.hexString())

            add("t", candidate.text)

            switch candidate.figure {
            case .none: break
            case .autoCharacter(let character):   add("fa", String(character))
            case .customCharacter(let character): add("fc", String(character))
            }

            let voteWords = candidate.votes.map { $0.description }
            let voteString = voteWords.joined(separator: ",")
            add("v", voteString)
        }

        var components = URLComponents()
        components.queryItems = queryItems
        guard let url = components.url else {
            fatalError("Failed to create URL from ballot components")
        }
        return url
    }

    convenience init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("Failed to get URL components from URL: \(url.relativeString)")
            return nil
        }
        guard let queryItems = components.queryItems else {
            print("Failed to get URL query items from URL components: \(url.relativeString)")
            return nil
        }

        var state: State?
        var questionText: String?
        var candidates: [Candidate] = []
        var didVoteVoterIDs: [UUID] = []

        var candidateColorString,
            candidateBackgroundColorString,
            candidateTextString,
            candidateFigureAutoCharacterString,
            candidateFigureCustomCharacterString,
            candidateVoteString: String?

        func addCandidate() {
            guard
                let colorString = candidateColorString,
                let color = UIColor(hexString: colorString),
                let backgroundColorString = candidateBackgroundColorString,
                let backgroundColor = UIColor(hexString: backgroundColorString)
                else { return }
            let figure: Figure
            if let character = candidateFigureAutoCharacterString?.characters.first {
                figure = .autoCharacter(character)
            } else if let character = candidateFigureCustomCharacterString?.characters.first {
                figure = .customCharacter(character)
            } else {
                figure = .none
            }
            let votes: [Int]
            if let voteString = candidateVoteString {
                let voteWords = voteString.components(separatedBy: ",")
                votes = voteWords.flatMap { Int($0) }
            } else {
                votes = []
            }
            let candidate = Candidate(
                color: color,
                backgroundColor: backgroundColor,
                text: candidateTextString,
                figure: figure,
                votes: votes
            )
            candidates.append(candidate)
            candidateColorString = nil
            candidateBackgroundColorString = nil
            candidateTextString = nil
            candidateFigureAutoCharacterString = nil
            candidateFigureCustomCharacterString =  nil
            candidateVoteString = nil
        }

        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }

            switch queryItem.name {
            case "s":
                state = State(rawValue: Int(value) ?? 0)
            case "q":
                questionText = value
            case "u":
                let voterIDComponents = value.components(separatedBy: ",")
                didVoteVoterIDs = voterIDComponents.flatMap { UUID(uuidString: $0) }
            case "c":
                candidateColorString = value
            case "b":
                candidateBackgroundColorString = value
            case "t":
                candidateTextString = value
            case "fa":
                candidateFigureAutoCharacterString = value
            case "fc":
                candidateFigureCustomCharacterString = value
            case "v":
                candidateVoteString = value
                addCandidate()
            default: break
            }
        }

        self.init(
            state: state ?? .votingSent,
            questionText: questionText,
            candidates: candidates,
            voterIDs: didVoteVoterIDs
        )
    }
}
