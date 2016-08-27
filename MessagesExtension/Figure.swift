//
//  Figure.swift
//  Bubble Vote
//
//  Created by Warren Whipple on 7/10/16.
//  Copyright © 2016 Warren Whipple. All rights reserved.
//

enum Figure: Equatable {
    case none, autoCharacter(Character), customCharacter(Character)
}

func ==(a: Figure, b: Figure) -> Bool {
    switch a {
    case .none:
        switch b {
        case .none: return true
        default: return false
        }
    case .autoCharacter(let characterA):
        switch b {
        case .autoCharacter(let characterB): return characterA == characterB
        default: return false
        }
    case .customCharacter(let characterA):
        switch b {
        case .customCharacter(let characterB): return characterA == characterB
        default: return false
        }
    }
}
