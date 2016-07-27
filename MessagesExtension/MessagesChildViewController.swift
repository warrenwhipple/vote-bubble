//
//  MessagesChildViewController.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/27/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

protocol MessagesChildViewController: class {
    var conversation: MSConversation! { get }
}
