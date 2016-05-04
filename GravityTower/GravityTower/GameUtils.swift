//
//  GameUtils.swift
//  GravityTower
//
//  Created by igmstudent on 5/2/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsCategory {
    static let None:  UInt32 = 0
    static let Edge:  UInt32 = 0b1 // 1
    static let Block: UInt32 = 0b10 // 2
    static let Base:  UInt32 = 0b100 // 4
    static let Label: UInt32 = 0b1000 // 8
    static let Goal:  UInt32 = 0b10000 // 16
}

struct SpriteLayer {
    static let Background   : CGFloat = 0
    static let PlayableRect : CGFloat = 1
    static let HUD          : CGFloat = 2
    static let Sprite       : CGFloat = 3
    static let Message      : CGFloat = 4
}

protocol CustomNodeEvents {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}