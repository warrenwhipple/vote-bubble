//
//  BrowseViewController.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/9/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

protocol BrowseViewControllerDelegate: class {
    func browseSelect(ballot: Ballot, with conversation: MSConversation)
}

class BrowseViewController: UICollectionViewController {

    private(set) weak var delegate: BrowseViewControllerDelegate!
    private(set) var ballots: [Ballot]!
    private(set) var conversation: MSConversation!

    func initConnect(delegate: BrowseViewControllerDelegate,
                     ballots: [Ballot],
                     conversation: MSConversation) {
        self.delegate = delegate
        self.ballots = ballots
        self.conversation = conversation
    }

    // MARK: - UICollectionViewDelegate methods

    override func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate.browseSelect(ballot: Ballot.simpleYesNo(), with: conversation)
        } else {
            delegate.browseSelect(ballot: Ballot.simpleYesNo(), with: conversation)
        }
    }

    // MARK: - UICollectionViewDataSource methods

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return (ballots.count ?? 0) + 1
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
