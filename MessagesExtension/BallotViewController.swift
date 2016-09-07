//
//  BallotViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BallotViewControllerDelegate: class {

}

class BallotViewController: UIViewController {

    var ballot: Ballot
    var ballotView: BallotView! { get { return view as! BallotView } }
    weak var delegate: BallotViewControllerDelegate?

    init(ballot: Ballot) {
        self.ballot = ballot
        super.init(nibName: nil, bundle: nil)
        self.view = BallotView()
        for candidate in ballot.candidates {
            let candidateView = SynchronizedFigureCaptionView()
            let candidateFigureText: String? = {
                switch candidate.figure {
                case .none: return nil
                case .autoCharacter  (let character): return String(character)
                case .customCharacter(let character): return String(character)
                }
            }()
            if let figure = candidateFigureText {
                candidateView.load(figure: figure)
            }
            if let text = candidate.text {
                candidateView.load(caption: text)
            }
            candidateView.backgroundColor = candidate.backgroundColor
            candidateView.textColor = candidate.textColor
            ballotView.bubbleView.add(candidateView: candidateView)
        }
        if let questionText = ballot.questionText {
            let questionLabel = UILabel()
            questionLabel.text = questionText
            ballotView.bubbleView.add(questionLabel: questionLabel)
        }
        let bubbleView = ballotView.bubbleView
        bubbleView.shouldDiplayFigures = ballot.anyCandidateFigures()
        bubbleView.shouldDisplayText = ballot.anyCandidateText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - User interface triggers

    func addCandidate() {
        let previousColors = ballot.candidates.map { $0.backgroundColor }
        let backgroundColor = UIColor.furthest(from: previousColors)
        let textColor = (backgroundColor.brightness < 0.5) ? UIColor.white : UIColor.black
        let candidate = Candidate(
            text: nil,
            figure: .none,
            textColor: textColor,
            backgroundColor: backgroundColor
        )
        ballot.candidates.append(candidate)
        let candidateView = SynchronizedFigureCaptionView()
        ballotView.bubbleView.add(candidateView: candidateView)
    }
}
