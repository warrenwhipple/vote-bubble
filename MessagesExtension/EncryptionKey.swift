//
//  EncryptionKey.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/7/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation

private let keySize = 16
private let ivSize  =  8

private func randomBytes(_ count: Int) -> [UInt8] {
    var randomBytes = [UInt8](repeating: 0, count: count)
    randomBytes.withUnsafeMutableBufferPointer() { arc4random_buf($0.baseAddress, count) }
    return randomBytes
}

private extension Data {
    var bytes: [UInt8] {
        return withUnsafeBytes() {
            [UInt8](UnsafeBufferPointer(start: $0, count: count))
        }
    }
}

struct EncryptionKey {

    let bytes: [UInt8]

    init() {
        bytes = randomBytes(keySize)
    }

    init?(base64EncodedForURL: String) {
        guard let data = Data(base64EncodedForURL: base64EncodedForURL) else {
            print("String was not base 64 encoded")
            return nil
        }
        guard data.count == keySize else {
            print("String was incorrect size")
            return nil
        }
        bytes = data.bytes
    }

    var base64EncodedForURLString: String {
        let data = Data(bytes: bytes)
        return data.base64EncodedForURLString()
    }

    func encrypt(_ string: String) -> Data? {
        let ivBytes = randomBytes(ivSize)
        let stringBytes = [UInt8](string.utf8)
        guard let encryptedBytes = chaCha20(message: stringBytes,
                                            key: self.bytes,
                                            iv: ivBytes) else { return nil }
        return Data(bytes: ivBytes + encryptedBytes)
    }

    func decrypt(_ data: Data) -> String? {
        guard data.count >= ivSize else { return nil }
        let bytes = data.bytes
        let ivBytes = [UInt8](bytes[0 ..< ivSize])
        let message = [UInt8](bytes[ivSize ..< bytes.count])
        guard let decryptedBytes = chaCha20(message: message,
                                            key: self.bytes,
                                            iv: ivBytes) else { return nil }
        let decryptedData = Data(bytes: decryptedBytes)
        return String(bytes: decryptedData, encoding: .utf8)
    }
}
