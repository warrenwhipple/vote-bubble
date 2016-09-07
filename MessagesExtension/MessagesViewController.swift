//
//  MessagesViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController,
    BallotCollectionViewControllerDelegate, BallotViewControllerDelegate {

    enum Mode { case collection, single }
    var mode: Mode = .collection

    let ballotStorage = BallotStorage()

    var collectionViewController: BallotCollectionViewController?
    var singleViewController: BallotViewController?

    /// Selected ballot waiting for transition to expanded presentation mode to complete
    var waitingBallot: Ballot? = nil
    /// Selected cell waiting for transition to expanded presentation mode to complete
    var waitingCell: UICollectionViewCell? = nil

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("VoteBubble view.didAppear(animated: \(animated)).")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func segueToSingleView(for ballot: Ballot, from cell: UICollectionViewCell? = nil) {
        if let oldSingleViewController = singleViewController {
            oldSingleViewController.delegate = nil
            unembed(childViewController: oldSingleViewController)
        }
        singleViewController = BallotViewController(ballot: ballot)
        embed(childViewController: singleViewController!, anchorToGuides: true)
        singleViewController!.delegate = self
        if let collectionViewController = collectionViewController {
            collectionViewController.delegate = nil
            unembed(childViewController: collectionViewController)
        }
    }

    func segueToCollectionView(from election: Election) {
        segueToCollectionView(from: election.ballot)
    }

    func segueToCollectionView(from ballot: Ballot) {
        if collectionViewController == nil {
            collectionViewController = BallotCollectionViewController(ballotStorage: ballotStorage)
        }
        collectionViewController!.delegate = self
        embed(childViewController: collectionViewController!, anchorToGuides: false)
        guard let singleViewController = singleViewController else { return }
        unembed(childViewController: singleViewController)
        self.singleViewController = nil
    }

    func embed(childViewController: UIViewController, anchorToGuides: Bool) {
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(childViewController)
        let childView = childViewController.view!
        view.addSubview(childView)
        childView.leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        childView.rightAnchor
            .constraint(equalTo: view.rightAnchor)
            .isActive = true
        if anchorToGuides {
            childView.topAnchor
                .constraint(equalTo: topLayoutGuide.bottomAnchor)
                .isActive = true
            childView.bottomAnchor
                .constraint(equalTo: bottomLayoutGuide.topAnchor)
                .isActive = true
        } else {
            childView.topAnchor
                .constraint(equalTo: view.topAnchor)
                .isActive = true
            childView.bottomAnchor
                .constraint(equalTo: view.bottomAnchor)
                .isActive = true
        }
        childViewController.didMove(toParentViewController: self)
    }

    func unembed(childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }

    // MARK: - MSMessagesAppViewController methods

    override func willBecomeActive(with conversation: MSConversation) {
        // No super call in template
        if let singleViewController = singleViewController {
            singleViewController.delegate = nil
            unembed(childViewController: singleViewController)
            self.singleViewController = nil
        }
        if collectionViewController == nil {
            collectionViewController =
                BallotCollectionViewController(ballotStorage: ballotStorage)
        }
        embed(childViewController: collectionViewController!, anchorToGuides: false)
        collectionViewController!.delegate = self
    }

    override func didResignActive(with conversation: MSConversation) {
        // No super call in template
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        // TODO: Add save user state
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // No super call in template
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        // Use this method to trigger UI updates in response to the message.
    }

    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // No super call in template
        // Called when the user taps the send button.
    }

    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // No super call in template
        // Called when the user deletes the message without sending it.
        // Use this to clean up state related to the deleted message.
    }

    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // No super call in template
        // Called before the extension transitions to a new presentation style.
        // Use this method to prepare for the change in presentation style.
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // No super call in template
        // Called after the extension transitions to a new presentation style.
        // Use this method to finalize any behaviors associated with the change in
        // presentation style.
        switch presentationStyle {
        case .compact: return
        case .expanded:
            if let ballot = waitingBallot {
                segueToSingleView(for: ballot, from: waitingCell)
                waitingBallot = nil
                waitingCell = nil
            }
        }
    }

    // MARK: - BallotCollectionViewControllerDelegate

    func collectionSelect(_ cell: UICollectionViewCell?, with ballot: Ballot) {
        switch presentationStyle {
        case .compact:
            waitingBallot = ballot
            waitingCell = cell
            requestPresentationStyle(.expanded)
        case .expanded:
            segueToSingleView(for: ballot, from: cell)
        }
    }

    // MARK: - Child view controller delegate methods

    func aprove(ballot: Ballot, with conversation: MSConversation) {
//        let election = Election(
//            session: nil,
//            cloudKitRecordID: nil,
//            status: .open,
//            voterIDs: [],
//            ballot: ballot,
//            votes: [[Int]](repeatElement([], count: ballot.candidates.count))
//        )
//        presentVoteView(for: election, with: conversation)
    }

    func vote(for candidateIndex: Int, in election: Election, with conversation: MSConversation) {
//        election.recordVote(
//            voterID: conversation.localParticipantIdentifier,
//            candidateIndex: candidateIndex
//        )
//        let message = election.message(sender: conversation.localParticipantIdentifier)
//        conversation.insert(message)
//        presentBrowseView(with: conversation)
//        requestPresentationStyle(.compact)
    }

    func declineToVote(in election: Election, with conversation: MSConversation) {
//        let message = election.message(sender: conversation.localParticipantIdentifier)
//        conversation.insert(message)
//        presentBrowseView(with: conversation)
//        requestPresentationStyle(.compact)
    }

    func dismissVote(in election: Election, with conversation: MSConversation) {
//        presentBuildView(for: election.ballot, conversation: conversation)
    }

    func dismissReport(for election: Election, with conversation: MSConversation) {
//        presentBrowseView(with: conversation)
//        requestPresentationStyle(.compact)
    }
}
