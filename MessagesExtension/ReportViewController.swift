//
//  ReportViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol ReportViewControllerDelegate: class {
    func dismissReport()
}

class ReportViewController: UITableViewController {

    weak var delegate: ReportViewControllerDelegate?
    
}
