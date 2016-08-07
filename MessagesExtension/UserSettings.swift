//
//  UserSettings.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/2/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation

extension MessagesViewController {

    func setupUserSettings() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingsStoreDidChange(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default()
        )
        NSUbiquitousKeyValueStore.default().synchronize()
    }

    func settingsStoreDidChange(_ store: NSUbiquitousKeyValueStore) {

    }

}
