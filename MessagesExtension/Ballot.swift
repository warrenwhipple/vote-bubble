//
//  Ballot.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

struct Ballot {

    var questionText: String?
    var candidates: [Candidate]

    init() {
        questionText = nil
        candidates = []
    }

    init(questionText: String?, candidates: [Candidate]) {
        self.questionText = questionText
        self.candidates = candidates
    }

    func messageImage() -> UIImage? {
        let size = MSMessageTemplateLayout.defaultImageSize
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let brickRects = rect.bricks(count: candidates.count)
        let scale = MSMessageTemplateLayout.defaultImageScale
        let opacity = true
        UIGraphicsBeginImageContextWithOptions(size, opacity, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to create graphics context")
            return nil
        }
        for (candidate, brickRect) in zip(candidates, brickRects) {
            candidate.draw(context: context, rect: brickRect)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Failed to get image from image context")
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }

    static func newWithPlaceholders() -> Ballot {
        let hueA = CGFloat.random(0 ..< 1)
        let hueB = hueA < 0.5 ? hueA + 0.5 : hueA - 0.5
        let colorA = UIColor(hue: hueA, saturation: 1, brightness: 0.75, alpha: 1)
        let colorB = UIColor(hue: hueB, saturation: 1, brightness: 0.75, alpha: 1)
        return Ballot(
            questionText: nil,
            candidates: [Candidate(text: nil,
                                   figure: .none,
                                   textColor: UIColor.white,
                                   backgroundColor: colorA),
                         Candidate(text: nil,
                                   figure: .none,
                                   textColor: UIColor.white,
                                   backgroundColor: colorB)]
        )
    }

    func anyCandidateFigures() -> Bool {
        for candidate in candidates {
            switch candidate.figure {
            case .autoCharacter, .customCharacter: return true
            case .none: continue
            }
        }
        return false
    }

    func anyCandidateText() -> Bool {
        for candidate in candidates {
            if candidate.text != nil {
                return true
            }
        }
        return false
    }
}
