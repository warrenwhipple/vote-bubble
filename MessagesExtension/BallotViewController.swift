//
//  BallotViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/14/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

class BallotViewController: UIViewController {

    var ballot: Ballot?
    var election: Election?

    init(ballot: Ballot) {
        self.ballot = ballot
        super.init(nibName: nil, bundle: nil)
    }

    init(election: Election) {
        self.election = election
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
