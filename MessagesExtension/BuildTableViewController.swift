//
//  BuildTableViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BuildTableViewControllerDelegate {
    var ballot: Ballot? { get }
}

class BuildTableViewController: UITableViewController {

    var delegate: BuildTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
