//
//  BrowseViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BrowseViewControllerDelegate: class {
    func didSelectBallot(_ ballot: Ballot)
}

class BrowseViewController: UIViewController {

    weak var delegate: BrowseViewControllerDelegate!
    
    @IBAction func newVotePressed(_ sender: UIButton, forEvent event: UIEvent) {
        delegate.didSelectBallot(Ballot.simpleYesNo())
    }
}
