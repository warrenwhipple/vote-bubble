//
//  CandidateBuildTableViewCell.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/13/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol CandidateBuildTableViewCellDelegate {
    func newCandidate() -> Candidate
}

class CandidateBuildTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var figureTextField: UITextField!
    @IBOutlet weak var textTextField: UITextField!
    private(set) var delegate: CandidateBuildTableViewCellDelegate!
    private(set) var candidate: Candidate?

    func load(delegate: CandidateBuildTableViewCellDelegate,
              candidate: Candidate?) {
        self.delegate = delegate
        load(candidate: candidate)
    }

    private func load(candidate: Candidate?) {
        self.candidate = candidate
        if let candidate = candidate {
            switch candidate.figure {
            case .none:                           figureTextField.text = nil
            case .autoCharacter(let character):   figureTextField.text = String(character)
            case .customCharacter(let character): figureTextField.text = String(character)
            }
            figureTextField.placeholder = "?"
            textTextField.text = candidate.text
            figureTextField.textColor = candidate.color
            textTextField.textColor = candidate.color
            contentView.backgroundColor = candidate.backgroundColor
        } else {
            figureTextField.placeholder = "+"
            figureTextField.text = nil
            textTextField.text = nil
            contentView.backgroundColor = UIColor.lightGray
        }
    }

    @IBAction func figureTextFieldEditingDidBegin(_ sender: UITextField) {
        if candidate == nil {
            load(candidate: delegate.newCandidate())
        }
    }

    @IBAction func textTextFieldEditingDidBegin(_ sender: UITextField) {
        if candidate == nil {
            load(candidate: delegate.newCandidate())
        }
    }
    

    @IBAction func figureTextFieldEditingChanged(_ sender: UITextField) {
        if let lastCharacter = sender.text?.characters.last {
            sender.text = String(lastCharacter)
            candidate?.figure = .customCharacter(lastCharacter)
        } else {
            sender.text = nil
            candidate?.figure = .none
        }
    }

    @IBAction func textTextFieldEditingChanged(_ sender: UITextField) {
        candidate?.text = sender.text
        switch candidate?.figure ?? .none {
        case .none, .autoCharacter:
            if let firstCharacter = sender.text?.characters.first {
                candidate?.figure = .autoCharacter(firstCharacter)
                figureTextField.text = String(firstCharacter)
            } else {
                candidate?.figure = .none
                figureTextField.text = nil
            }
        default: break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Text field return pressed")
        return false
    }

    private func sizeFigureText() {
        let height = figureTextField.frame.height
        guard let candidate = candidate else {
            figureTextField.font = UIFont.systemFont(ofSize: height * 2 / 3)
            return
        }
        switch candidate.figure {
        case .none, .autoCharacter, .customCharacter: UIFont.systemFont(ofSize: height * 2 / 3)
        }
    }

}
