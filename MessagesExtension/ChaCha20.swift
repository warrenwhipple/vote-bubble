//
//  ChaCha20.swift
//  VoteBubble
//
//  Created by Warren Whipple on 8/11/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//


private func rotateLeft(_ value: UInt32, by: UInt32) -> UInt32 {
    return (value << by) | (value >> (32 &- by))
}

private func bytesLittleEndian(word: UInt32) -> [UInt8] {
    return [UInt8((word      ) & UInt32(0xFF)),
            UInt8((word >>  8) & UInt32(0xFF)),
            UInt8((word >> 16) & UInt32(0xFF)),
            UInt8((word >> 24) & UInt32(0xFF)) ]
}

private func word(bytesLittleEndian: [UInt8], from: Int) -> UInt32 {
    assert(from + 4 < bytesLittleEndian.count)
    return ((UInt32(bytesLittleEndian[from &+ 0])      ) |
            (UInt32(bytesLittleEndian[from &+ 1]) <<  8) |
            (UInt32(bytesLittleEndian[from &+ 2]) << 16) |
            (UInt32(bytesLittleEndian[from &+ 3]) << 24)   )
}

private func chaCha20Core(_ input: [UInt32]) -> [UInt8] {
    assert(input.count == 16)
    var x = input
    func quarterRound(_ a: Int, _ b: Int, _ c: Int, _ d: Int) {
        x[a] = x[a] &+ x[b]; x[d] = rotateLeft(x[d] ^ x[a], by: 16)
        x[c] = x[c] &+ x[d]; x[b] = rotateLeft(x[b] ^ x[c], by: 12)
        x[a] = x[a] &+ x[b]; x[d] = rotateLeft(x[d] ^ x[a], by:  8)
        x[c] = x[c] &+ x[d]; x[b] = rotateLeft(x[b] ^ x[c], by:  7)
    }
    for _ in 0 ..< 10 { // 10 * 8 quarter rounds = 20 rounds
        quarterRound(0, 4,  8, 12)
        quarterRound(1, 5,  9, 13)
        quarterRound(2, 6, 10, 14)
        quarterRound(3, 7, 11, 15)
        quarterRound(0, 5, 10, 15)
        quarterRound(1, 6, 11, 12)
        quarterRound(2, 7,  8, 13)
        quarterRound(3, 4,  9, 14)
    }
    for i in 0 ..< 16 {
        x[i] = x[i] &+ input[i]
    }
    var output: [UInt8] = []
    output.reserveCapacity(64)
    for word in x {
        output.append(contentsOf: bytesLittleEndian(word: word))
    }
    return output
}

// Sigma and tau are constants used in the original C ChaCha code by D. J. Bernstein.
// The integers used below are the ascii
// https://cr.yp.to/chacha.html
private let sigma: [UInt8] = "expand 32-byte k".unicodeScalars.map { UInt8($0.value) }
private let tau:   [UInt8] = "expand 16-byte k".unicodeScalars.map { UInt8($0.value) }

func chaCha20(message: [UInt8], key: [UInt8], nonce: [UInt8], counter: UInt64 = 0) -> [UInt8]? {

    let constants: [UInt8]
    let keyShift: Int

    switch key.count {
    case 32:
        constants = sigma
        keyShift = 16
    case 16:
        constants = tau
        keyShift = 0
    default:
        print("Encryption key is \(key.count) bytes")
        print("ChaCha20 encryption key must be 16 bytes (128-bit) or 32 bytes (256-bit)")
        return nil
    }

    guard nonce.count == 8 else {
        print("Nonce is \(nonce.count) bytes")
        print("ChaCha20 nonce must be 8 bytes")
        return nil
    }

    guard !message.isEmpty else { return [] }

    var context: [UInt32] = [
        word(bytesLittleEndian: constants, from:              0),
        word(bytesLittleEndian: constants, from:              4),
        word(bytesLittleEndian: constants, from:              8),
        word(bytesLittleEndian: constants, from:             12),
        word(bytesLittleEndian: key,       from:              0),
        word(bytesLittleEndian: key,       from:              4),
        word(bytesLittleEndian: key,       from:              8),
        word(bytesLittleEndian: key,       from:             12),
        word(bytesLittleEndian: key,       from: keyShift &+  0),
        word(bytesLittleEndian: key,       from: keyShift &+  4),
        word(bytesLittleEndian: key,       from: keyShift &+  8),
        word(bytesLittleEndian: key,       from: keyShift &+ 12),
        UInt32(counter & 0xFFFFFFFF),
        UInt32(counter >> 32),
        word(bytesLittleEndian: nonce,     from:              0),
        word(bytesLittleEndian: nonce,     from:              4)
    ]

    var cipher: [UInt8] = []
    cipher.reserveCapacity(message.count)

    while (true) {
        let encryptionBlock = chaCha20Core(context)
        context[12] = context[12] &+ 1
        if context[12] == 0 {
            context[13] = context[13] &+ 1
        }
        let byteCountLeft = message.count - cipher.count
        if byteCountLeft <= 64 {
            for i in 0 ..< byteCountLeft {
                cipher.append(message[cipher.count] ^ encryptionBlock[i])
            }
            return cipher
        }
        for i in 0 ..< 64 {
            cipher.append(message[cipher.count] ^ encryptionBlock[i])
        }
    }

}
