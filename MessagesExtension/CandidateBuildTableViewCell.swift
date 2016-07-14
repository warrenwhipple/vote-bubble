//
//  CandidateBuildTableViewCell.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/13/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol CandidateBuildTableViewCellDelegate {
    
}

class CandidateBuildTableViewCell: UITableViewCell {

    @IBOutlet weak var figureView: UIView!
    @IBOutlet weak var textField: UITextField!
    var delegate: CandidateBuildTableViewCellDelegate?
    private(set) var candidate: Candidate?

    func loadCandidate(_ candidate: Candidate?) {
        self.candidate = candidate
        textField.text = candidate?.text
        contentView.backgroundColor = candidate?.backgroundColor ?? UIColor.lightGray()
        textField.textColor = candidate?.color ?? UIColor.white()
    }
}
