//
//  QuestionBuildTableViewCell.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/13/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol QuestionBuildTableViewCellDelegate {
    func approve(ballot: Ballot)
}

class QuestionBuildTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    private(set) var delegate: QuestionBuildTableViewCellDelegate!
    private(set) var ballot: Ballot!

    var lastLastQuestionCharacterWasSpace = false

    func load(delegate: QuestionBuildTableViewCellDelegate,
              ballot: Ballot) {
        self.delegate = delegate
        self.ballot = ballot
        textField.text = ballot.questionText
    }

    @IBAction func didPressStartVote(_ sender: UIButton) {
        delegate.approve(ballot: ballot!)
    }

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        // Replace auto period with auto questionmark
        if var characters = sender.text?.characters {
            if characters.popLast() == " " {
                if lastLastQuestionCharacterWasSpace {
                    if characters.popLast() == "." {
                        sender.text = String(characters) + "? "
                    }
                }
                lastLastQuestionCharacterWasSpace = true
            } else {
                lastLastQuestionCharacterWasSpace = false
            }
        } else {
            lastLastQuestionCharacterWasSpace = false
        }
        ballot!.questionText = sender.text
    }
}
