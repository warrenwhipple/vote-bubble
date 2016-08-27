//
//  BallotViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BallotViewController: UIViewController {

    let messageBubbleView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messageBubbleView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
