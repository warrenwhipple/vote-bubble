//
//  BuildViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BuildViewControllerDelegate: class {
    func didAproveBallot(_ ballot: Ballot)
}

class BuildViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    weak var buildViewControllerDelegate: BuildViewControllerDelegate!
    private(set) var ballot: Ballot!

    func loadBallot(_ ballot: Ballot) {
        self.ballot = ballot
    }

    @IBAction func doneAction(_ sender: AnyObject) {
        print("done action")
    }
}
