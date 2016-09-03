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

    weak var delegate: BallotViewControllerDelegate?
    let ballotBubbleView = BallotBubbleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(ballotBubbleView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
