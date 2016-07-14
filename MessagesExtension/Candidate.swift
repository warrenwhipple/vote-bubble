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
        func textBox(text: String, fontSizeRatio: CGFloat) {
            let label = UILabel(frame: rect)
            label.textColor = color
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: rect.size.height * fontSizeRatio)
            label.text = text
            let origin = label.frame.origin
            context.translate(x: origin.x, y: origin.y)
            label.layer.render(in: context)
            context.translate(x: -origin.x, y: -origin.y)
        }
        switch figure {
        case .none:
            break
        case .text(let word):
            textBox(text: word, fontSizeRatio: 1/6)
        case .autoCharacter(let character):
            textBox(text: String(character), fontSizeRatio: 2/3)
        case .customCharacter(let character):
            textBox(text: String(character), fontSizeRatio: 2/3)
        }
    }
}
