//
//  Candidate.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/8/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

struct Candidate {

    var text: String?
    var figure: Figure
    var textColor, backgroundColor: UIColor

    func draw(context: CGContext?, rect: CGRect) {
        guard let context = context else { return }
        context.setFillColor(backgroundColor.cgColor)
        context.fill(rect)
        func textBox(text: String, fontSizeRatio: CGFloat) {
            let label = UILabel(frame: rect)
            label.textColor = textColor
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: rect.size.height * fontSizeRatio)
            label.text = text
            let origin = label.frame.origin
            context.translateBy(x: origin.x, y: origin.y)
            label.layer.render(in: context)
            context.translateBy(x: -origin.x, y: -origin.y)
        }
        switch figure {
        case .none:
            break
        case .autoCharacter(let character):
            textBox(text: String(character), fontSizeRatio: 2/3)
        case .customCharacter(let character):
            textBox(text: String(character), fontSizeRatio: 2/3)
        }
    }
}
