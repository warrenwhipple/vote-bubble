//
//  Candidate.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/8/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class Candidate {

    var color, backgroundColor: UIColor
    var text: String?
    var figure: Figure
    var votes: [UUID?]

    init(color: UIColor,
         backgroundColor: UIColor,
         text: String? = nil,
         figure: Figure = .none,
         votes: [UUID?] = []) {

        self.color = color
        self.backgroundColor = backgroundColor
        self.text = text
        self.figure = figure
        self.votes = votes
    }

    func draw(context: CGContext?, rect: CGRect) {
        guard let context = context else { return }
        context.setFillColor(backgroundColor.cgColor)
        context.fill(rect)
        switch figure {
        case .none:
            break
        case .text(let word):
            let label = UILabel(frame: rect)
            label.textColor = color
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: rect.size.height / 8)
            label.text = word
            let origin = label.frame.origin
            context.translate(x: origin.x, y: origin.y)
            label.layer.render(in: context)
            context.translate(x: -origin.x, y: -origin.y)
        case .character(let character):
            let label = UILabel(frame: rect)
            label.textColor = color
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: rect.size.height * 2 / 3)
            label.text = String(character)
            let origin = label.frame.origin
            context.translate(x: origin.x, y: origin.y)
            label.layer.render(in: context)
            context.translate(x: -origin.x, y: -origin.y)
        }
    }
}
