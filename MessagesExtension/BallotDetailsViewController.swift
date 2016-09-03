//
//  BallotDetailsViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BallotDetailsViewController: UIViewController {

    var ballotDetailsView: BallotDetailsView! {
        get { return view as! BallotDetailsView }
    }

    init(election: Election) {
        super.init(nibName: nil, bundle: nil)
        view = BallotDetailsView()
        for candidate in election.ballot.candidates {
            let candidateView = SynchronizedFigureCaptionView()
            switch candidate.figure {
            case .none: break
            case .autoCharacter  (let character): candidateView.load(figure: String(character))
            case .customCharacter(let character): candidateView.load(figure: String(character))
            }
            if let text = candidate.text {
                candidateView.load(caption: text)
            }
            candidateView.backgroundColor = candidate.backgroundColor
            candidateView.textColor = candidate.textColor
            ballotDetailsView.ballotBubbleView.add(candidateView: candidateView)
        }
        if let questionText = election.ballot.questionText {
            let questionLabel = UILabel()
            questionLabel.text = questionText
            ballotDetailsView.ballotBubbleView.add(questionLabel: questionLabel)
        }
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
}
