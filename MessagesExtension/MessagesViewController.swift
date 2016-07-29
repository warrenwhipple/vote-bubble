//
//  MessagesViewController.swift
//  Vote Bubble
//
//  Created by Warren Whipple on 7/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import UIKit
import Messages

let defaultBallots = [Ballot.simpleYesNo(), Ballot.simpleYesNo()]

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
        print("MSMessagesAppViewController.viewDidAppear()")
        super.viewDidAppear(animated)
        anticipatedPresentationStyle = presentationStyle
    }

    override func didReceiveMemoryWarning() {
        print("MSMessagesAppViewController.didReceiveMemoryWarning()")
        if embeddedChildViewController != browseViewController {
            browseViewController = nil
        }
        super.didReceiveMemoryWarning()
    }

    func presentInferredView(for message: MSMessage, with conversation: MSConversation) {
        if let ballot = Ballot(message: message) {
            switch ballot.status {
            case .open:
                if ballot.didVote(conversation.localParticipantIdentifier) {
                    presentReportView(for: ballot, with: conversation)
                } else {
                    presentVoteView(for: ballot, with: conversation)
                }
            case .closed:
                presentReportView(for: ballot, with: conversation)
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
        requestPresentationStyle(.expanded)
    }

    func presentVoteView(for ballot: Ballot, with conversation: MSConversation) {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "VoteViewController"
            ) as! VoteViewController
        viewController.delegate = self
        viewController.ballot = ballot
        viewController.conversation = conversation
        embed(newChildViewController: viewController)
        requestPresentationStyle(.expanded)
    }

    func presentReportView(for ballot: Ballot, with conversation: MSConversation) {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "ReportViewController"
            ) as! ReportViewController
        viewController.delegate = self
        viewController.ballot = ballot
        viewController.conversation = conversation
        embed(newChildViewController: viewController)
        requestPresentationStyle(.expanded)
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
        if let message = conversation.selectedMessage {
            presentInferredView(for: message, with: conversation)
        } else {
            presentBrowseView(with: conversation)
        }
        print("MSMessagesAppViewController.willBecomeActive()")
        super.willBecomeActive(with: conversation)
    }

    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        print("MSMessagesAppViewController.didResignActive()")
        // TODO: Add save user state
        super.didResignActive(with: conversation)
    }

    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.willSelect()")
        super.willSelect(message, conversation: conversation)
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didSelect()")
        if let selectedMessage = conversation.selectedMessage {
            presentInferredView(for: selectedMessage, with: conversation)
        } else {
            presentBrowseView(with: conversation)
        }
        super.didSelect(message, conversation: conversation)
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didReceive()")
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        // Use this method to trigger UI updates in response to the message.
        super.didReceive(message, conversation: conversation)
    }

    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didStartSending()")
        super.didStartSending(message, conversation: conversation)
    }

    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didCancelSending()")
        super.didCancelSending(message, conversation: conversation)
    }

    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        anticipatedPresentationStyle = presentationStyle
        if presentationStyle == .compact {
            presentBrowseView(
                with: activeConversation ??
                    (embeddedChildViewController as! MessagesChildViewController).conversation!
            )
        }
        print("MSMessagesAppViewController.willTransition()")
        super.willTransition(to: presentationStyle)
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        anticipatedPresentationStyle = presentationStyle
        print("MSMessagesAppViewController.didTransition()")
        super.didTransition(to: presentationStyle)
    }

    override func requestPresentationStyle(_ presentationStyle: MSMessagesAppPresentationStyle) {
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
    }

    func aprove(ballot: Ballot, with conversation: MSConversation) {
        presentVoteView(for: ballot, with: conversation)
    }

    func vote(for candidate: Candidate, on ballot: Ballot, with conversation: MSConversation) {
        ballot.recordVote(voterID: conversation.localParticipantIdentifier, candidate: candidate)
        let message = ballot.message(sender: conversation.localParticipantIdentifier)
        conversation.insert(message)
        presentBrowseView(with: conversation)
        requestPresentationStyle(.compact)
    }

    func declineToVote(on ballot: Ballot, with conversation: MSConversation) {
        let message = ballot.message(sender: conversation.localParticipantIdentifier)
        conversation.insert(message)
        presentBrowseView(with: conversation)
        requestPresentationStyle(.compact)
    }

    func dismissVote(on ballot: Ballot, with conversation: MSConversation) {
        presentBuildView(for: ballot, conversation: conversation)
    }

    func dismissReport(ballot: Ballot, with conversation: MSConversation) {
        presentBrowseView(with: conversation)
        requestPresentationStyle(.compact)
    }
}
