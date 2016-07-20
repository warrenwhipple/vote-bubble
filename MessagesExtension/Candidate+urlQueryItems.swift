//
//  Candidate+urlQueryItems.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/20/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

extension Candidate {

    convenience init?(urlQueryItems: [URLQueryItem]) {
        guard !urlQueryItems.isEmpty else { return nil }

        var color: UIColor?
        var backgroundColor: UIColor?
        var text: String?
        var figure: Figure?
        var votes: [Int]?

        for queryItem in urlQueryItems {
            guard let value = queryItem.value else { continue }
            switch queryItem.name {
            case "c":
                color = UIColor(hexString: value)
            case "b":
                backgroundColor = UIColor(hexString: value)
            case "t":
                text = value
            case "fa":
                figure = .autoCharacter(value.characters.first ?? " ")
            case "fc":
                figure = .customCharacter(value.characters.first ?? " ")
            case "v":
                let componenets = value.components(separatedBy: ",")
                votes = componenets.flatMap { Int($0) }
            default: break
            }
        }

        guard let initColor = color, let initBackgroundColor = backgroundColor else { return nil }
        self.init(
            color: initColor,
            backgroundColor: initBackgroundColor,
            text: text,
            figure: figure ?? .none,
            votes: votes ?? []
        )
    }

    func urlQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []

        func add(_ name: String, _ value: String?) {
            guard let value = value , !value.isEmpty else { return }
            queryItems.append(URLQueryItem(name: name, value: value))
        }

        add("c", color.hexString())

        add("b", backgroundColor.hexString())

        add("t", text)

        switch figure {
        case .none: break
        case .autoCharacter(let character):   add("fa", String(character))
        case .customCharacter(let character): add("fc", String(character))
        }

        let voteWords = votes.map { $0.description }
        let voteString = voteWords.joined(separator: ",")
        add("v", voteString)

        return queryItems
    }
}
