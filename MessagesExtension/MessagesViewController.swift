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

    var embeddedChildViewController: UIViewController!
    var browseViewController: BrowseViewController!

    var cachedBrowseViewController: BrowseViewController?

    enum ViewMode { case browsing, building, voting, reporting }
    var viewMode: ViewMode {
        if embeddedChildViewController is BrowseViewController { return .browsing  }
        if embeddedChildViewController is BuildViewController  { return .building  }
        if embeddedChildViewController is VoteViewController   { return .voting    }
        if embeddedChildViewController is ReportViewController { return .reporting }
        fatalError("Unrecognized child view controller")
    }

    override func viewDidAppear(_ animated: Bool) {
        print("MSMessagesAppViewController.viewDidAppear()")
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        print("MSMessagesAppViewController.didReceiveMemoryWarning()")
        if embeddedChildViewController != browseViewController {
            browseViewController = nil
        }
        super.didReceiveMemoryWarning()
    }

    func instantiateBrowseViewController(conversation: MSConversation) -> BrowseViewController {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "BrowseViewController"
            ) as! BrowseViewController
        viewController.delegate = self
        viewController.ballots = defaultBallots
        viewController.conversation = conversation
        return viewController
    }

    func instantiateBuildViewController(ballot: Ballot,
                                        conversation: MSConversation) -> BuildViewController {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "BuildViewController"
            ) as! BuildViewController
        viewController.delegate = self
        viewController.ballot = ballot
        viewController.conversation = conversation
        return viewController
    }

    func instantiateVoteViewController(ballot: Ballot,
                                       conversation: MSConversation) -> VoteViewController {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "VoteViewController"
            ) as! VoteViewController
        viewController.delegate = self
        viewController.ballot = ballot
        viewController.conversation = conversation
        return viewController
    }

    func instantiateReportViewController(ballot: Ballot,
                                         conversation: MSConversation) -> ReportViewController {
        let viewController = storyboard!.instantiateViewController(
            withIdentifier: "ReportViewController"
            ) as! ReportViewController
        viewController.delegate = self
        viewController.ballot = ballot
        viewController.conversation = conversation
        return viewController
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

    func transitionToBrowseViewMode(with conversation: MSConversation) {
        if browseViewController == nil {
            browseViewController = instantiateBrowseViewController(conversation: conversation)
        } else {
            browseViewController.conversation = conversation
        }
        embed(newChildViewController: browseViewController)
    }

    func transition(to newViewMode: ViewMode,
                    for ballot: Ballot,
                    with conversation: MSConversation) {
        let controller: UIViewController
        switch newViewMode {
        case .browsing:
            fatalError("Use transitionToBrowseViewMode() to transition to browse view mode")
        case .building:
            controller = instantiateBuildViewController(ballot: ballot, conversation: conversation)
        case .voting:
            controller = instantiateVoteViewController(ballot: ballot, conversation: conversation)
        case.reporting:
            controller = instantiateReportViewController(ballot: ballot, conversation: conversation)
        }
        embed(newChildViewController: controller)
        requestPresentationStyle(.expanded)
    }

    // MARK: - MSMessagesAppViewController methods

    override func willBecomeActive(with conversation: MSConversation) {
        if browseViewController == nil {
            browseViewController = instantiateBrowseViewController(conversation: conversation)
        }
        if embeddedChildViewController == nil {
            embed(newChildViewController: browseViewController)
        }
        print("MSMessagesAppViewController.willBecomeActive()")
    }

    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        print("MSMessagesAppViewController.didResignActive()")
        print("Save user state not yet implemented!")
        // TODO: Add save user state
    }

    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.willSelect()")
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didSelect()")
        guard let ballot = Ballot(message: message) else {
            print("Message could not be converted to ballot")
            transitionToBrowseViewMode(with: conversation)
            return
        }
        switch ballot.status {
        case .unsent:
            transition(to: .building, for: ballot, with: conversation)
        case .open:
            if ballot.didVote(conversation.localParticipantIdentifier) {
                transition(to: .reporting, for: ballot, with: conversation)
            } else {
                transition(to: .voting, for: ballot, with: conversation)
            }
        case .closed:
            transition(to: .reporting, for: ballot, with: conversation)
        }
    }

    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didReceive()")
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        // Use this method to trigger UI updates in response to the message.
    }

    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didStartSending()")
    }

    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didCancelSending()")
    }

    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        print("MSMessagesAppViewController.willTransition()")
        if presentationStyle == .compact {
            transitionToBrowseViewMode(
                with: activeConversation ??
                    (embeddedChildViewController as! MessagesChildViewController).conversation!
            )
        }
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        print("MSMessagesAppViewController.didTransition()")
        view.setNeedsLayout()
    }

    // MARK: - Child view controller delegate methods

    func browseSelect(ballot: Ballot, with conversation: MSConversation) {
        transition(to: .building, for: ballot, with: conversation)
    }

    func aprove(ballot: Ballot, with conversation: MSConversation) {
        transition(to: .voting, for: ballot, with: conversation)
    }

    func vote(for candidate: Candidate, on ballot: Ballot, with conversation: MSConversation) {
        ballot.recordVote(voterID: conversation.localParticipantIdentifier, candidate: candidate)
        let message = ballot.message(sender: conversation.localParticipantIdentifier)
        conversation.insert(message)
        transitionToBrowseViewMode(with: conversation)
        requestPresentationStyle(.compact)
    }

    func declineToVote(on ballot: Ballot, with conversation: MSConversation) {
        let message = ballot.message(sender: conversation.localParticipantIdentifier)
        conversation.insert(message)
        transition(to: .browsing, for: ballot, with: conversation)
        requestPresentationStyle(.compact)
    }

    func dismissVote(on ballot: Ballot, with conversation: MSConversation) {
        transition(to: .building, for: ballot, with: conversation)
    }

    func dismissReport(ballot: Ballot, with conversation: MSConversation) {
        transition(to: .browsing, for: ballot, with: conversation)
        requestPresentationStyle(.compact)
    }
}
