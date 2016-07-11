//
//  ReportViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol ReportViewControllerDelegate: class {
    func didDismissBallotReport(ballot: Ballot)
}

class ReportViewController: UIViewController {

    weak var delegate: ReportViewControllerDelegate!
    private(set) var ballot: Ballot!

    func loadBallot(_ ballot: Ballot) {
        self.ballot = ballot
    }

    @IBAction func donePressed(_ sender: AnyObject) {
        delegate.didDismissBallotReport(ballot: ballot)
    }

}
