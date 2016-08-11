//
//  MessagesViewController.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController:
    MSMessagesAppViewController,
    BrowseViewControllerDelegate,
    BuildViewControllerDelegate,
    VoteViewControllerDelegate,
    ReportViewControllerDelegate {

    var anticipatedPresentationStyle: MSMessagesAppPresentationStyle = .compact
    var embeddedChildViewController: UIViewController!
    var browseViewController: BrowseViewController!

    override func viewDidAppear(_ animated: Bool) {
        print("Messages app view did appear")
        super.viewDidAppear(animated)
        anticipatedPresentationStyle = presentationStyle
        Election().testCloudKit()
    }

    override func didReceiveMemoryWarning() {
        print("Messages app did recieve memory warning")
        if embeddedChildViewController != browseViewController {
            browseViewController = nil
        }
        super.didReceiveMemoryWarning()
    }

    func presentInferredView(for message: MSMessage, with conversation: MSConversation) {
        if let election = Election(message: message) {
            switch election.status {
            case .open:
                if election.didVote(conversation.localParticipantIdentifier) {
                    presentReportView(for: election, with: conversation)
                } else {
                    presentVoteView(for: election, with: conversation)
                }
            case .closed:
                presentReportView(for: election, with: conversation)
            }
        } else {
            print("Message could not be converted to ballot")
            presentBrowseView(with: conversation)
        }
    }

    func presentBrowseView(with conversation: MSConversation) {
        if browseViewController == nil {
            browseViewController = storyboard!.instantiateViewController(
                withIdentifier: "BrowseViewController"
                ) as! BrowseViewController
            browseViewController.delegate = self
            browseViewController.ballots = defaultBallots
        }
        browseViewController.conversation = conversation
        embed(newChildViewController: browseViewController)
    }

    func presentBuildView(for ballot: Ballot, conversation: MSConversation) {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "BuildViewController"
            ) as! BuildViewController
        viewController.delegate = self
        viewController.ballot = ballot
        viewController.conversation = conversation
        embed(newChildViewController: viewController)
    }

    func presentVoteView(for election: Election, with conversation: MSConversation) {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "VoteViewController"
            ) as! VoteViewController
        viewController.delegate = self
        viewController.election = election
        viewController.conversation = conversation
        embed(newChildViewController: viewController)
    }

    func presentReportView(for election: Election, with conversation: MSConversation) {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "ReportViewController"
            ) as! ReportViewController
        viewController.delegate = self
        viewController.election = election
        viewController.conversation = conversation
        embed(newChildViewController: viewController)
    }

    func embed(newChildViewController: UIViewController) {
        if let oldChildViewController = embeddedChildViewController {
            oldChildViewController.view.removeFromSuperview()
            oldChildViewController.willMove(toParentViewController: nil)
            oldChildViewController.removeFromParentViewController()
        }
        embeddedChildViewController = newChildViewController
        newChildViewController.willMove(toParentViewController: self)
        addChildViewController(newChildViewController)
        let newChildView = newChildViewController.view!
        newChildView.translatesAutoresizingMaskIntoConstraints = false
        newChildViewController.view.frame = view.bounds
        view.addSubview(newChildView)
        newChildView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newChildView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        newChildView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        newChildView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newChildViewController.didMove(toParentViewController: self)
    }

    // MARK: - MSMessagesAppViewController methods

    override func willBecomeActive(with conversation: MSConversation) {
        print("Messages app will become active")
        if let message = conversation.selectedMessage {
            presentInferredView(for: message, with: conversation)
        } else {
            presentBrowseView(with: conversation)
        }
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
        presentInferredView(for: message, with: conversation)
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
        if presentationStyle == .compact {
            presentBrowseView(
                with: activeConversation ??
                    (embeddedChildViewController as! MessagesChildViewController).conversation!
            )
        }
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
        presentBuildView(for: ballot, conversation: conversation)
        requestPresentationStyle(.expanded)
    }

    func aprove(ballot: Ballot, with conversation: MSConversation) {
        let election = Election(
            session: nil,
            cloudKitRecordID: nil,
            status: .open,
            voterIDs: [],
            ballot: ballot,
            votes: [[Int]](repeatElement([], count: ballot.candidates.count))
        )
        presentVoteView(for: election, with: conversation)
    }

    func vote(for candidateIndex: Int, in election: Election, with conversation: MSConversation) {
        election.recordVote(
            voterID: conversation.localParticipantIdentifier,
            candidateIndex: candidateIndex)
        let message = election.message(sender: conversation.localParticipantIdentifier)
        conversation.insert(message)
        presentBrowseView(with: conversation)
        requestPresentationStyle(.compact)
    }

    func declineToVote(in election: Election, with conversation: MSConversation) {
        let message = election.message(sender: conversation.localParticipantIdentifier)
        conversation.insert(message)
        presentBrowseView(with: conversation)
        requestPresentationStyle(.compact)
    }

    func dismissVote(in election: Election, with conversation: MSConversation) {
        presentBuildView(for: election.ballot, conversation: conversation)
    }

    func dismissReport(for election: Election, with conversation: MSConversation) {
        presentBrowseView(with: conversation)
        requestPresentationStyle(.compact)
    }
}
