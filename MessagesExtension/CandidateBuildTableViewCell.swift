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
    var delegate: CandidateBuildTableViewCellDelegate?
    private(set) var candidate: Candidate?

    func loadCandidate(_ candidate: Candidate?) {
        self.candidate = candidate
        if let candidate = candidate {
            switch candidate.figure {
            case .none:                           figureTextField.text = nil
            case .text(let text):                 figureTextField.text = text
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
            contentView.backgroundColor = UIColor.lightGray()
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Text field return pressed")
        return false
    }

}
