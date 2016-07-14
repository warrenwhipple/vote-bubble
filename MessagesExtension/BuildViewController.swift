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

class BuildViewController: UIViewController, BuildTableViewControllerDelegate {

    @IBOutlet weak var doneButton: UIButton!
    weak var buildTableViewController: BuildTableViewController?
    weak var delegate: BuildViewControllerDelegate?
    var ballot: Ballot? { return delegate?.ballot }
    var lastQuestionCharacterWasSpace = false

    override func viewDidLoad() {
        super.viewDidLoad()
        for viewController in childViewControllers {
            if let buildTableViewController = viewController as? BuildTableViewController {
                self.buildTableViewController = buildTableViewController
                buildTableViewController.delegate = self
                print(buildTableViewController)
                break
            }
        }

    }
    
    // MARK: - BuildViewControllerDelegate methods

    func didApproveBallot() {
        delegate?.didAproveBallot()
    }
}
