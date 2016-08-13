//
//  BallotCollectionViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BallotCollectionViewControllerDelegate: class {
    func ballotCollectionSelect(ballot: Ballot)
}

private let newBallotCellReuseIdentifier   = "NewBallotCell"
private let savedBallotCellReuseIdentifier = "SavedBallotCell"

class BallotCollectionViewController: UICollectionViewController {

    weak var delegate: BallotCollectionViewControllerDelegate?
    var ballots: [Ballot]

    init(ballots: [Ballot]) {
        self.ballots = ballots
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        collectionView!.register(NewBallotCell.self,
                                 forCellWithReuseIdentifier: newBallotCellReuseIdentifier)
        collectionView!.register(SavedBallotCell.self,
                                 forCellWithReuseIdentifier: savedBallotCellReuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return ballots.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: newBallotCellReuseIdentifier,
                for: indexPath) as! NewBallotCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: savedBallotCellReuseIdentifier,
                for: indexPath) as! SavedBallotCell
                cell.load(ballot: ballots[indexPath.row - 1])
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate?.ballotCollectionSelect(ballot: Ballot())
        } else {
            delegate?.ballotCollectionSelect(ballot: ballots[indexPath.row - 1])
        }
    }

}
