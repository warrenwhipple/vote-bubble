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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        let spacing = flowLayout.minimumInteritemSpacing
        flowLayout.sectionInset =
            UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        super.init(collectionViewLayout: flowLayout)
        collectionView!.register(NewBallotCell.self,
                                 forCellWithReuseIdentifier: newBallotCellReuseIdentifier)
        collectionView!.register(SavedBallotCell.self,
                                 forCellWithReuseIdentifier: savedBallotCellReuseIdentifier)
        collectionView!.backgroundColor = UIColor.white
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
        let cell: UICollectionViewCell
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: newBallotCellReuseIdentifier,
                for: indexPath)
        } else {
            let savedBallotCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: savedBallotCellReuseIdentifier,
                for: indexPath) as! SavedBallotCell
            savedBallotCell.load(ballot: ballots[indexPath.row - 1])
            cell = savedBallotCell
        }
        cell.layer.cornerRadius = 16
        cell.clipsToBounds = true
        return cell
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
