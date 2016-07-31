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

    init(questionText: String?, candidates: [Candidate]) {
        self.questionText = questionText
        self.candidates = candidates
    }

    func messageImage() -> UIImage? {
        let (messageSize, answerRects) = CGRect.bricks(
            containerWidth: MSMessageTemplateLayout.defaultWidth,
            count: candidates.count
        )
        let scale = MSMessageTemplateLayout.defaultScale
        let opaque = true
        UIGraphicsBeginImageContextWithOptions(messageSize, opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to create graphics context")
            return nil
        }
        for (answer, rect) in zip(candidates, answerRects) {
            answer.draw(context: context, rect: rect)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Failed to get image from image context")
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }

    static func new() -> Ballot {
        return Ballot(questionText: nil, candidates: [])
    }
}
