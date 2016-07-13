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
    var lastQuestionCharacterWasSpace = false


    func loadBallot(_ ballot: Ballot) {
        self.ballot = ballot
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextField.text = ballot.questionText
    }

    @IBAction func questionTextEditingDidChange(_ sender: UITextField) {
        if var chars = sender.text?.characters {
            let lastChar = chars.popLast()
            if lastChar == " " {
                if lastQuestionCharacterWasSpace {
                    let secondToLastChar = chars.popLast()
                    if secondToLastChar == "." {
                        sender.text = String(chars) + "? "
                    }
                }
                lastQuestionCharacterWasSpace = true
            } else {
                lastQuestionCharacterWasSpace = false
            }
        } else {
            lastQuestionCharacterWasSpace = false
        }
        ballot.questionText = sender.text
    }

    @IBAction func doneAction(_ sender: AnyObject) {
        ballot.state = .votingUnsent
        buildViewControllerDelegate.didAproveBallot(ballot)
    }
}
