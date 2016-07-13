//
//  ReportViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol ReportViewControllerDelegate: class {
    var ballot: Ballot? { get }
    func didDismissBallotReport()
}

class ReportViewController: UIViewController {

    weak var delegate: ReportViewControllerDelegate!

    @IBAction func donePressed(_ sender: AnyObject) {
        delegate.didDismissBallotReport()
    }
}
