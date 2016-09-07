//
//  SynchronizedFigureCaptionView.swift
//  VoteBubble
//
//  Created by Warren Whipple on 9/1/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class SynchronizedFigureCaptionView: UIView {

    var figureLabel: UILabel?
    var captionLabel: UILabel?
    var smallSynchSize = CGSize.zero

    var displayStyle: FigureCaptionDisplayStyle = .none {
        didSet {
            if let figureLabel = figureLabel {
                switch displayStyle {
                case .figureOverCaption, .figureLeftOfCaption, .figureOnly:
                    insertSubview(figureLabel, at: 0)
                case .none, .captionOnly:
                    figureLabel.removeFromSuperview()
                }
            }
            if let captionLabel = captionLabel {
                switch displayStyle {
                case .figureOverCaption, .figureLeftOfCaption, .captionOnly:
                    addSubview(captionLabel)
                case .none, .figureOnly:
                    captionLabel.removeFromSuperview()
                }
            }
        }
    }

    var textColor: UIColor? {
        didSet {
            figureLabel?.textColor = textColor
            captionLabel?.textColor = textColor
        }
    }

    var figureFont: UIFont? {
        didSet {
            figureLabel?.font = figureFont
        }
    }

    var captionFont: UIFont? {
        didSet {
            captionLabel?.font = captionFont
        }
    }

    override var backgroundColor: UIColor? {
        didSet {
            figureLabel?.backgroundColor = backgroundColor
            captionLabel?.backgroundColor = backgroundColor
        }
    }

    func load(figure: String) {
        if figureLabel == nil {
            figureLabel = UILabel()
            figureLabel?.isOpaque = true
            figureLabel?.textAlignment = .center
            figureLabel?.backgroundColor = backgroundColor
            figureLabel?.textColor = textColor
            figureLabel?.font = figureFont
            switch displayStyle {
            case .figureOverCaption, .figureLeftOfCaption, .figureOnly:
                insertSubview(figureLabel!, at: 0)
            case .none, .captionOnly:
                break
            }
        }
        figureLabel?.text = figure
    }

    func load(caption: String) {
        if captionLabel == nil {
            captionLabel = UILabel()
            captionLabel?.isOpaque = true
            captionLabel?.backgroundColor = backgroundColor
            captionLabel?.textColor = textColor
            captionLabel?.font = captionFont
            switch displayStyle {
            case .figureOverCaption, .figureLeftOfCaption, .captionOnly:
                addSubview(captionLabel!)
            case .none, .figureOnly:
                break
            }
        }
        captionLabel?.text = caption
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        switch displayStyle {
        case .none: break
        case .figureOverCaption: layoutFigureOverCaption()
        case .figureLeftOfCaption: layoutFigureLeftOfCaption()
        case .figureOnly: layoutFigureOnly()
        case .captionOnly: layoutCaptionOnly()
        }
    }

    private func layoutFigureOverCaption() {
        let captionLayout = captionLabel?.withInsets(.relative, all: 0.1)
        let layout = SplitLayout(
            figureLabel,
            captionLayout,
            split: 0.75,
            direction: .vertical
        ).withCentering(.size(CGSize(width: bounds.width, height: smallSynchSize.height)))
        captionLabel?.textAlignment = .center
        layout.layout(in: bounds)
    }

    private func layoutFigureLeftOfCaption() {
        let layout = SplitLayout(
            figureLabel,
            captionLabel?.withInsets(.relative, all: 0.1),
            split: smallSynchSize.height / smallSynchSize.height,
            direction: .horizontal
        )
        captionLabel?.textAlignment = .left
        layout.layout(in: bounds)
    }

    private func layoutFigureOnly() {
        figureLabel?.layout(in: bounds)
    }

    private func layoutCaptionOnly() {
        let layout = captionLabel?.withInsets(.relative, all: 0.1)
        captionLabel?.textAlignment = .center
        layout?.layout(in: bounds)
    }
}
