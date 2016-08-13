//
//  MessagesViewController.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {

    var anticipatedPresentationStyle: MSMessagesAppPresentationStyle = .compact
    var ballotCollectionViewController: BallotCollectionViewController?

    override func viewDidLoad() {
        print("Messages app view did load")
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("Messages app view did appear")
        anticipatedPresentationStyle = presentationStyle
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        print("Messages app did recieve memory warning")
        super.didReceiveMemoryWarning()
    }

    func embedBallotCollectionView() {
        if ballotCollectionViewController == nil {
            ballotCollectionViewController = BallotCollectionViewController(ballots: defaultBallots)
        }
        let collectionView = ballotCollectionViewController!.collectionView!
        view.addSubview(collectionView)
        collectionView.leftAnchor  .constraint(equalTo: view.leftAnchor)  .isActive = true
        collectionView.rightAnchor .constraint(equalTo: view.rightAnchor) .isActive = true
        collectionView.topAnchor   .constraint(equalTo: view.topAnchor)   .isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        ballotCollectionViewController!.didMove(toParentViewController: self)
    }

    // MARK: - MSMessagesAppViewController methods

    override func willBecomeActive(with conversation: MSConversation) {
        print("Messages app will become active")
        embedBallotCollectionView()
        super.willBecomeActive(with: conversation)
    }

    override func didResignActive(with conversation: MSConversation) {
        print("Messages app did resign active")
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        // TODO: Add save user state
        super.didResignActive(with: conversation)
    }

    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        print("Messages app will select message")
        super.willSelect(message, conversation: conversation)
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        print("Messages app did select message")
        super.didSelect(message, conversation: conversation)
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        print("Messages app did receive        \(message)")
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        // Use this method to trigger UI updates in response to the message.
        super.didReceive(message, conversation: conversation)
    }

    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        print("Messages app did start sending  \(message)")
        super.didStartSending(message, conversation: conversation)
    }

    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        print("Messages app did cancel sending \(message)")
        super.didCancelSending(message, conversation: conversation)
    }

    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        print("Messages app will transition to " + (presentationStyle == .expanded ? "expanded" : "compact"))
        anticipatedPresentationStyle = presentationStyle
        super.willTransition(to: presentationStyle)
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        print("Messages app did transition to " + (presentationStyle == .expanded ? "expanded" : "compact"))
        anticipatedPresentationStyle = presentationStyle
        super.didTransition(to: presentationStyle)
    }

    override func requestPresentationStyle(_ presentationStyle: MSMessagesAppPresentationStyle) {
        print("Messages app request presentation style " + (presentationStyle == .expanded ? "expanded" : "compact"))
        guard presentationStyle != anticipatedPresentationStyle else {
            print("Requested presentation style \(presentationStyle) is already anticipated")
            return
        }
        anticipatedPresentationStyle = presentationStyle
        super.requestPresentationStyle(presentationStyle)
    }

    // MARK: - Child view controller delegate methods

    func browseSelect(ballot: Ballot, with conversation: MSConversation) {
        //presentBuildView(for: ballot, conversation: conversation)
        requestPresentationStyle(.expanded)
    }

    func aprove(ballot: Ballot, with conversation: MSConversation) {
        /*
        let election = Election(
            session: nil,
            cloudKitRecordID: nil,
            status: .open,
            voterIDs: [],
            ballot: ballot,
            votes: [[Int]](repeatElement([], count: ballot.candidates.count))
        )
        presentVoteView(for: election, with: conversation)
        */
    }

    func vote(for candidateIndex: Int, in election: Election, with conversation: MSConversation) {
        /*
        election.recordVote(
            voterID: conversation.localParticipantIdentifier,
            candidateIndex: candidateIndex)
        let message = election.message(sender: conversation.localParticipantIdentifier)
        conversation.insert(message)
        presentBrowseView(with: conversation)
        requestPresentationStyle(.compact)
        */
    }

    func declineToVote(in election: Election, with conversation: MSConversation) {
        /*
        let message = election.message(sender: conversation.localParticipantIdentifier)
        conversation.insert(message)
        presentBrowseView(with: conversation)
        requestPresentationStyle(.compact)
        */
    }

    func dismissVote(in election: Election, with conversation: MSConversation) {
        //presentBuildView(for: election.ballot, conversation: conversation)
    }

    func dismissReport(for election: Election, with conversation: MSConversation) {
        //presentBrowseView(with: conversation)
        //requestPresentationStyle(.compact)
    }
}
