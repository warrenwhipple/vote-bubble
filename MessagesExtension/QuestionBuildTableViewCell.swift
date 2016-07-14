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
}

class QuestionBuildTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var delegate: QuestionBuildTableViewCellDelegate?

    func load() {
        textField.text = delegate?.ballot?.questionText
    }
}
