//
//  BricksView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/7/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BricksView: UIView {

    private(set) var bricks: [UIView]

    init(bricks: [UIView], frame: CGRect) {
        self.bricks = bricks
        super.init(frame: frame)
        arrangeBricks(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        bricks = []
        super.init(coder: aDecoder)
    }

    func add(brick: UIView, animated: Bool) {
        if brick.superview != self {
            addSubview(brick)
        }
        bricks.append(brick)
        arrangeBricks(animated: animated)
    }

    func add(bricks: [UIView], animated: Bool) {
        for brick in bricks {
            if brick.superview != self {
                addSubview(brick)
            }
        }
        self.bricks.append(contentsOf: bricks)
        arrangeBricks(animated: animated)
    }

    func remove(at index: Int, animated: Bool) {
        guard index < bricks.count else { return }
        bricks.remove(at: index)
        arrangeBricks(animated: animated)
    }

    func arrangeBricks(animated: Bool) {
        let brickRects = bounds.bricks(count: bricks.count)
        if animated {

        } else {
            for (brick, brickRect) in zip (bricks, brickRects) {
                brick.frame = brickRect
            }
        }
    }
}
