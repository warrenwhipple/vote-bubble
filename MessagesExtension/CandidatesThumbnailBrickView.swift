//
//  CandidatesThumbnailBrickView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class CandidatesThumbnailBrickView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let brickRects = bounds.bricks(count: subviews.count)
        let smallBrickSize = brickRects.last?.size ?? bounds.size
        let smallEdge = min(smallBrickSize.width, smallBrickSize.height)
        for (subview, brickRect) in zip(subviews, brickRects) {
            subview.frame = brickRect
            guard let label = subview as? UILabel else { continue }
            label.font = UIFont.systemFont(ofSize: smallEdge * 2 / 3)
        }
    }
}
