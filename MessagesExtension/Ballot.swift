//
//  Ballot.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

class Ballot {
    var questionText: String?
    var candidates: [Candidate]

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

    static func new() -> Ballot {
        return Ballot(questionText: nil, candidates: [])
    }
}
