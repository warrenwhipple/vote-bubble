//
//  CandidateBrickView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/7/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol CandidateBrickViewDelegate: class {
}

class CandidateBrickView: UIView {

    weak var delegate: CandidateBrickViewDelegate?
    var candidateIndex: Int = 0

    let figureLabel = UILabel()
    let textLabel = UILabel()

    var figureFont: UIFont? {
        didSet {
            if let figureFont = figureFont {
                figureLabel.font = figureFont
                insertSubview(figureLabel, at: 0)
            } else {
                figureLabel.removeFromSuperview()
            }
        }
    }

    var textAttributes: [String : AnyObject]? {
        didSet {
            if let textAttributes = textAttributes {
                if let text = textLabel.attributedText?.string {
                    textLabel.attributedText = NSAttributedString(string: text,
                                                                  attributes: textAttributes)
                }
                addSubview(textLabel)
            } else {
                textLabel.removeFromSuperview()
            }
        }
    }

    init(candidate: Candidate, candidateIndex: Int) {
        self.candidateIndex = candidateIndex
        super.init(frame: CGRect.zero)
        figureLabel.backgroundColor = candidate.backgroundColor
        textLabel.backgroundColor = candidate.backgroundColor
        figureLabel.textColor = candidate.textColor
        figureLabel.textColor = candidate.textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if figureFont != nil && textAttributes != nil {
            figureLabel.frame = CGRect(x: 0,
                                       y: 0,
                                       width: bounds.width,
                                       height: bounds.height * 0.75)
            textLabel.frame =   CGRect(x: 0,
                                       y: bounds.height * 0.75,
                                       width: bounds.width,
                                       height: bounds.height * 0.25)
        } else if figureFont != nil {
            figureLabel.frame = bounds
        } else if textAttributes != nil {
            textLabel.frame = bounds
        }
    }
}
