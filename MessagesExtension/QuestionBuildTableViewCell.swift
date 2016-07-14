//
//  QuestionBuildTableViewCell.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/13/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol QuestionBuildTableViewCellDelegate {
    var ballot: Ballot? { get }
    func didApproveBallot()
}

class QuestionBuildTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    var delegate: QuestionBuildTableViewCellDelegate?
    var lastLastQuestionCharacterWasSpace = false

    func load() {
        textField.text = delegate?.ballot?.questionText
    }

    @IBAction func didPressStartVote(_ sender: UIButton) {
        delegate?.didApproveBallot()
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
        delegate?.ballot?.questionText = sender.text
    }
}
