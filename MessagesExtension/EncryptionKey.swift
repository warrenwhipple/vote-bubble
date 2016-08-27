//
//  EncryptionKey.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/7/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation

private func randomBytes(_ count: Int) -> [UInt8] {
    var randomBytes = [UInt8](repeating: 0, count: count)
    randomBytes.withUnsafeMutableBufferPointer() {
        arc4random_buf($0.baseAddress, count)
    }
    return randomBytes
}

struct EncryptionKey {

    static let keySize = 16
    static let ivSize  =  8

    let bytes: [UInt8]

    init() {
        bytes = randomBytes(EncryptionKey.keySize)
    }

    init?(base64EncodedForURL: String) {
        guard let data = Data(base64EncodedForURL: base64EncodedForURL) else {
            print("String was not base 64 encoded")
            return nil
        }
        guard data.count == EncryptionKey.keySize else {
            print("String was incorrect size")
            return nil
        }
        bytes = data.withUnsafeBytes() {
            [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
        }
    }

    var base64EncodedForURLString: String {
        let data = Data(bytes: bytes)
        return data.base64EncodedForURLString()
    }

    func encrypt(_ string: String) -> Data? {
        let nonceBytes = randomBytes(EncryptionKey.ivSize)
        let stringBytes = [UInt8](string.utf8)
        guard let encryptedBytes = chaCha20(message: stringBytes,
                                            key: self.bytes,
                                            nonce: nonceBytes) else { return nil }
        return Data(bytes: nonceBytes + encryptedBytes)
    }

    func decrypt(_ data: Data) -> String? {
        guard data.count >= EncryptionKey.ivSize else { return nil }
        let bytes = data.withUnsafeBytes() {
            [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
        }
        let nonceBytes = [UInt8](bytes[0 ..< EncryptionKey.ivSize])
        let message = [UInt8](bytes[EncryptionKey.ivSize ..< bytes.count])
        guard let decryptedBytes = chaCha20(message: message,
                                            key: self.bytes,
                                            nonce: nonceBytes) else { return nil }
        let decryptedData = Data(bytes: decryptedBytes)
        return String(bytes: decryptedData, encoding: .utf8)
    }

}
