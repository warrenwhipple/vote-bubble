//
//  Ballot+url.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/19/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

private let uuidStringLength = UUID().uuidString.characters.count

extension Ballot {

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
        var didVoteVoterIDs: [UUID] = []
        var candidateQueryItems: [URLQueryItem] = []
        var candidates: [Candidate] = []

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
                if let candidate = Candidate(urlQueryItems: candidateQueryItems) {
                    candidates.append(candidate)
                    candidateQueryItems.removeAll()
                }
                candidateQueryItems.append(queryItem)
            default:
                candidateQueryItems.append(queryItem)
            }
        }
        if let candidate = Candidate(urlQueryItems: candidateQueryItems) {
            candidates.append(candidate)
        }
        self.init(
            state: state ?? .votingSent,
            questionText: questionText,
            candidates: candidates,
            voterIDs: didVoteVoterIDs
        )
    }

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
            queryItems.append(contentsOf: candidate.urlQueryItems())
        }

        var components = URLComponents()
        components.queryItems = queryItems
        guard let url = components.url else {
            fatalError("Failed to create URL from ballot components")
        }
        return url
    }
}
