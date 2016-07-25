//
//  BrowseViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit

protocol BrowseViewControllerDelegate: class {
    func browseSelect(ballot: Ballot)
}

class BrowseViewController: UICollectionViewController {

    weak var delegate: BrowseViewControllerDelegate?
    var ballots: [Ballot] = []

    // MARK: - UICollectionViewDelegate methods

    override func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate?.browseSelect(ballot: Ballot.simpleYesNo())
        } else {
            delegate?.browseSelect(ballot: Ballot.simpleYesNo())
        }
    }

    // MARK: - UICollectionViewDataSource methods

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return ballots.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "NewBallotCell",
                for: indexPath
            )
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SavedBallotCell",
                for: indexPath
            )
            return cell
        }
    }
}
