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
            UInt8((word >> 24) & UInt32(0xFF))]
}

private func wordLittleEndian(bytes: [UInt8], from: Int) -> UInt32 {
    return ((UInt32(bytes[from &+ 0])      ) |
        (UInt32(bytes[from &+ 1]) <<  8) |
        (UInt32(bytes[from &+ 2]) << 16) |
        (UInt32(bytes[from &+ 3]) << 24)  )

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
        quarterRound( 0,  4,  8, 12)
        quarterRound( 1,  5,  9, 13)
        quarterRound( 2,  6, 10, 14)
        quarterRound( 3,  7, 11, 15)
        quarterRound( 0,  5, 10, 15)
        quarterRound( 1,  6, 11, 12)
        quarterRound( 2,  7,  8, 13)
        quarterRound( 3,  4,  9, 14)
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

// sigma and tau are constants used in the original C ChaCha code by D. J. Bernstein
// https://cr.yp.to/chacha.html
// static const char sigma[16] = "expand 32-byte k";
// static const char tau[16] = "expand 16-byte k";
private let sigma: [UInt8] = [101,120,112,97,110,100,32,51,50,45,98,121,116,101,32,107]
private let tau:   [UInt8] = [101,120,112,97,110,100,32,49,54,45,98,121,116,101,32,107]

private func context(key: [UInt8], iv: [UInt8], counter: UInt64) -> [UInt32]? {
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
    guard iv.count == 8 else {
        print("Initialization vector is \(key.count) bytes")
        print("ChaCha20 initialization vector must be 8 bytes")
        return nil
    }
    var context = [UInt32](repeating: 0, count: 16)
    context[ 0] = wordLittleEndian(bytes: constants, from:              0)
    context[ 1] = wordLittleEndian(bytes: constants, from:              4)
    context[ 2] = wordLittleEndian(bytes: constants, from:              8)
    context[ 3] = wordLittleEndian(bytes: constants, from:             12)
    context[ 4] = wordLittleEndian(bytes: key,       from:              0)
    context[ 5] = wordLittleEndian(bytes: key,       from:              4)
    context[ 6] = wordLittleEndian(bytes: key,       from:              8)
    context[ 7] = wordLittleEndian(bytes: key,       from:             12)
    context[ 8] = wordLittleEndian(bytes: key,       from: keyShift &+  0)
    context[ 9] = wordLittleEndian(bytes: key,       from: keyShift &+  4)
    context[10] = wordLittleEndian(bytes: key,       from: keyShift &+  8)
    context[11] = wordLittleEndian(bytes: key,       from: keyShift &+ 12)
    context[12] = UInt32(counter & 0xFFFFFF)
    context[13] = UInt32(counter >> 32)
    context[14] = wordLittleEndian(bytes: iv,        from:              0)
    context[15] = wordLittleEndian(bytes: iv,        from:              4)
    return context
}

func chaCha20(message: [UInt8], key: [UInt8], iv: [UInt8], counter: UInt64 = 0) -> [UInt8]? {
    guard var blockInput = context(key: key, iv: iv, counter: counter) else { return nil }
    guard !message.isEmpty else { return [] }
    var cipher = [UInt8](repeating: 0, count: message.count)
    var byteCountDone = 0
    var byteCountLeft = message.count
    while (true) {
        let blockOutput = chaCha20Core(blockInput)
        blockInput[12] = blockInput[12] &+ 1
        if blockInput[12] == 0 {
            blockInput[13] = blockInput[13] &+ 1
        }
        if byteCountLeft <= 64 {
            for i in 0 ..< byteCountLeft {
                cipher[byteCountDone &+ i] = message[byteCountDone &+ i] ^ blockOutput[i]
            }
            return cipher
        }
        for i in 0 ..< 64 {
            cipher[byteCountDone &+ i] = message[byteCountDone &+ i] ^ blockOutput[i]
        }
        byteCountDone = byteCountDone &+ 64
        byteCountLeft = byteCountLeft &- 64
    }
}
