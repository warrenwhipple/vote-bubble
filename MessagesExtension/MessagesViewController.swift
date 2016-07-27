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

    private(set) var ballot: Ballot?
    private(set) var primaryChildViewController: UIViewController?

    enum ViewMode { case browsing, building, voting, reporting }
    var viewMode: ViewMode? {
        guard let childViewController = primaryChildViewController else { return nil        }
        if childViewController is BrowseViewController                  { return .browsing  }
        if childViewController is BuildViewController                   { return .building  }
        if childViewController is VoteViewController                    { return .voting    }
        if childViewController is ReportViewController                  { return .reporting }
        fatalError("Unrecognized child view controller")
    }

    override func viewDidAppear(_ animated: Bool) {
        print("MSMessagesAppViewController.viewDidAppear()")
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        print("MSMessagesAppViewController.didReceiveMemoryWarning()")
        super.didReceiveMemoryWarning()
    }

    func transitionToInferredViewMode(with conversation: MSConversation) {
        if let message = conversation.selectedMessage {
            ballot = Ballot(message: message)
        }
        guard let ballot = ballot else {
            transition(to: .browsing, with: conversation)
            return
        }
        switch ballot.status {
        case .unsent:
            transition(to: .building, with: conversation)
        case .open:
            if ballot.didVote(conversation.localParticipantIdentifier) {
                transition(to: .reporting, with: conversation)
            } else {
                transition(to: .voting, with: conversation)
            }
        case .closed:
            transition(to: .reporting, with: conversation)
        }
    }

    func transition(to newViewMode: ViewMode, with conversation: MSConversation) {
        let storyboardID: String
        switch newViewMode {
        case .browsing:  storyboardID = "BrowseViewController"
        case .building:  storyboardID = "BuildViewController"
        case .voting:    storyboardID = "VoteViewController"
        case .reporting: storyboardID = "ReportViewController"
        }
        guard let newChildViewController =
            storyboard?.instantiateViewController(withIdentifier: storyboardID) else {
                fatalError("Failed to instantiate storyboard \(storyboardID)")
        }

        switch newViewMode {
        case .browsing:
            let browseViewController = newChildViewController as! BrowseViewController
            browseViewController.delegate = self
            browseViewController.ballots = [Ballot.simpleYesNo(), Ballot.simpleYesNo()]
        case .building:
            let buildViewController = newChildViewController as! BuildViewController
            buildViewController.delegate = self
            if presentationStyle == .compact { requestPresentationStyle(.expanded) }
        case .voting:
            let voteViewController = newChildViewController as! VoteViewController
            voteViewController.delegate = self
            if presentationStyle == .compact { requestPresentationStyle(.expanded) }
        case .reporting:
            let reportViewController = newChildViewController as! ReportViewController
            reportViewController.delegate = self
            if presentationStyle == .compact { requestPresentationStyle(.expanded) }
        }

        if let oldChildViewController = primaryChildViewController {
            oldChildViewController.view.removeFromSuperview()
            oldChildViewController.willMove(toParentViewController: nil)
            oldChildViewController.removeFromParentViewController()
        }

        primaryChildViewController = newChildViewController

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
        print("MSMessagesAppViewController.willBecomeActive()")
        transitionToInferredViewMode(with: conversation)
    }

    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
        print("MSMessagesAppViewController.didResignActive()")
    }

    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.willSelect()")
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        print("MSMessagesAppViewController.didSelect()")
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
        if presentationStyle == .compact && viewMode != .browsing {
            transition(to: .browsing, with: activeConversation!)
        }
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        print("MSMessagesAppViewController.didTransition()")
    }

    // MARK: - Child view controller delegate methods

    func browseSelect(ballot: Ballot) {
        self.ballot = ballot
        transition(to: .building, with: activeConversation!)
    }

    func aproveBallot() {
        transition(to: .voting, with: activeConversation!)
    }

    func vote(for candidate: Candidate) {
        ballot!.recordVote(
            voterID: activeConversation!.localParticipantIdentifier,
            candidate: candidate
        )
        let message = ballot!.message(sender: activeConversation!.localParticipantIdentifier)
        activeConversation!.insert(message)
        transition(to: .browsing, with: activeConversation!)
        requestPresentationStyle(.compact)
    }

    func declineToVote() {
        let message = ballot!.message(sender: activeConversation!.localParticipantIdentifier)
        activeConversation!.insert(message)
        transition(to: .browsing, with: activeConversation!)
        requestPresentationStyle(.compact)
    }

    func cancelVote() {
        transition(to: .building, with: activeConversation!)
    }

    func dismissReport() {
        transition(to: .browsing, with: activeConversation!)
        requestPresentationStyle(.compact)
    }
}
