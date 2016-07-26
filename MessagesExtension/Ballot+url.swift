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

        var status: Status?
        var questionText: String?
        var didVoteVoterIDs: [UUID] = []
        var candidateQueryItems: [URLQueryItem] = []
        var candidates: [Candidate] = []

        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }

            switch queryItem.name {
            case "s":
                if value == "c" { status = .closed }
            case "q":
                questionText = value
            case "u":
                let voterIDComponents = value.components(separatedBy: ",")
                didVoteVoterIDs = voterIDComponents.flatMap { UUID(base64String: $0) }
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
            status: status ?? .open,
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

        if status == .closed {
            add("s", "c")
        }

        add("q", questionText)

        let voterIDWords = voterIDs.map { $0.base64String }
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
        print("Ballot to URL: \(url.relativeString)")
        return url
    }
}
