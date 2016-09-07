//
//  BallotCollectionViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BallotCollectionViewControllerDelegate: class {
    func collectionSelect(_ cell: UICollectionViewCell?, with ballot: Ballot)
}

private let newBallotCellReuseIdentifier   = "NewBallotCell"
private let savedBallotCellReuseIdentifier = "SavedBallotCell"

class BallotCollectionViewController: UICollectionViewController {

    let ballotStorage: BallotStorage
    weak var delegate: BallotCollectionViewControllerDelegate?

    init(ballotStorage: BallotStorage) {
        self.ballotStorage = ballotStorage
        let flowLayout = UICollectionViewFlowLayout()
        // TODO: Dynamically determine cell spacing
        // This is hard coded for 320pt wide display
        flowLayout.itemSize = CGSize(width: 90, height: 90)
        flowLayout.minimumLineSpacing = 12.5
        flowLayout.sectionInset = UIEdgeInsets(top: 12.5, left: 12.5, bottom: 12.5, right: 12.5)
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

    func save(ballot: Ballot) {
        ballotStorage.save(ballot)
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView?.insertItems(at: [indexPath])
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return ballotStorage.savedBallots.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: newBallotCellReuseIdentifier,
                for: indexPath)
        } else {
            let savedBallotCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: savedBallotCellReuseIdentifier,
                for: indexPath) as! SavedBallotCell
            savedBallotCell.load(ballot: ballotStorage.savedBallots[indexPath.row - 1])
            cell = savedBallotCell
        }
        cell.layer.cornerRadius = 16
        cell.clipsToBounds = true
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if indexPath.row == 0 {
            delegate?.collectionSelect(cell, with: Ballot())
        } else {
            delegate?.collectionSelect(cell, with: ballotStorage.savedBallots[indexPath.row - 1])
        }
    }
}
