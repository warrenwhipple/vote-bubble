//
//  BuildViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BuildViewControllerDelegate: class {
    var ballot: Ballot? { get }
    func didAproveBallot()
}

class BuildViewController: UIViewController {

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    weak var tableViewController: BuildTableViewController!
    weak var delegate: BuildViewControllerDelegate?
    var lastQuestionCharacterWasSpace = false

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let ballot = delegate?.ballot else { return }
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
        delegate?.ballot?.questionText = sender.text
    }

    @IBAction func doneAction(_ sender: AnyObject) {
        delegate?.ballot?.state = .votingUnsent
        delegate?.didAproveBallot()
    }
}
