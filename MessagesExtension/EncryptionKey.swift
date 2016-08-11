//
//  EncryptionKey.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/7/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

import Foundation
import CryptoSwift

class EncryptionKey {

    static let byteCount = 16 // 128 bits / 8 bits per byte

    private static func randomBytes() -> [UInt8] {
        var randomBytes = [UInt8](repeating: 0, count: EncryptionKey.byteCount)
        randomBytes.withUnsafeMutableBufferPointer() {
            arc4random_buf($0.baseAddress, EncryptionKey.byteCount)
        }
        return randomBytes
    }

    let bytes: [UInt8]

    init() {
        bytes = EncryptionKey.randomBytes()
    }

    init?(base64EncodedForURL: String) {
        guard let data = Data(base64EncodedForURL: base64EncodedForURL) else {
            print("String was not base 64 encoded")
            return nil
        }
        guard data.count > EncryptionKey.byteCount else {
            print("Encryption key requires at least \(EncryptionKey.byteCount) bytes")
            print("Only \(data.count) bytes were supplied")
            return nil
        }
        bytes = data.bytes
    }

    var base64EncodedForURLString: String {
        let data = Data(bytes: bytes)
        return data.base64EncodedForURLString()
    }

    func encrypt(_ string: String) -> Data? {
        let ivBytes = EncryptionKey.randomBytes()
        do {
            let encryptor = try ChaCha20(key: bytes, iv: ivBytes)
            let stringBytes = [UInt8](string.utf8)
            let encryptedBytes = try encryptor.encrypt(stringBytes)
            return Data(bytes: ivBytes + encryptedBytes)
        } catch {
            print(error)
            return nil
        }
    }

    func decrypt(_ data: Data) -> String? {
        guard data.count >= 16 else { return nil }
        let bytes = data.bytes
        let ivBytes = [UInt8](bytes[0 ..< EncryptionKey.byteCount])
        let encryptedBytes = [UInt8](bytes[EncryptionKey.byteCount ..< bytes.count])
        do {
            let encryptor = try ChaCha20(key: self.bytes, iv: ivBytes)
            let decryptedBytes = try encryptor.decrypt(encryptedBytes)
            return String(bytes: decryptedBytes, encoding: .utf8)
        } catch {
            print(error)
            return nil
        }
    }
}
