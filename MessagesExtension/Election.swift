//
//  Election.swift
//  VoteBubble
//
//  Created by Warren Whipple on 7/31/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Messages

class Election {

    var session: MSSession?
    var cloudKitRecordID: UUID
    var encryptionKey: EncryptionKey
    enum Status: Int { case open, closed }
    var status: Status
    let ballot: Ballot
    var voters: [Voter]
    var votes: [[Int]]

    init() {
        session = nil
        cloudKitRecordID = UUID()
        encryptionKey = EncryptionKey()
        status = .open
        ballot = Ballot()
        voters = []
        votes = []
    }

    init(ballot: Ballot) {
        session = nil
        cloudKitRecordID = UUID()
        encryptionKey = EncryptionKey()
        status = .open
        self.ballot = ballot
        voters = []
        votes = []
    }

    init(session: MSSession?,
         cloudKitRecordID: UUID,
         encryptionKey: EncryptionKey,
         status: Status,
         ballot: Ballot,
         voters: [Voter],
         votes: [[Int]]) {
        self.session = session
        self.cloudKitRecordID = cloudKitRecordID
        self.encryptionKey = encryptionKey
        self.status = status
        self.ballot = ballot
        self.voters = voters
        self.votes = votes
    }

    func didVote(_ voter: Voter) -> Bool {
        for didVoteVoter in voters {
            if voter.cloudKitUserID == didVoteVoter.cloudKitUserID {
                return true
            }
        }
        return false
    }

    func recordVote(voter: Voter, candidateIndex: Int) {
        guard !didVote(voter) else { print("Voter already voted"); return }
        votes[candidateIndex].append(voters.count)
        voters.append(voter)
    }
}
