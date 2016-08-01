//
//  Election+CloudKit.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages
import CloudKit

extension Election {
    func testCloudKit() {
        let container = CKContainer.default()
        container.accountStatus() {
            (accountStatus, error) in
            print(accountStatus)
            print(error)
        }
        //let database = container.publicCloudDatabase
    }
}
