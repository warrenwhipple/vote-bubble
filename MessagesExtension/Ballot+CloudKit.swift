//
//  Ballot+CloudKit.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/30/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation
import CloudKit

extension Ballot {

    func testCloudKit() {
        let container = CKContainer.default()
        let recordID = CKRecordID(recordName: UUID().uuidString)
        let record = CKRecord(recordType: "Ballot", recordID: recordID)
        let database = container.publicCloudDatabase
    }
}
