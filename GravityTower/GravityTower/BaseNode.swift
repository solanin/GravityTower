//
//  BaseNode.swift
//  GravityTower
//
//  Created by igmstudent on 4/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, CustomNodeEvents {
    func didMoveToScene() {
        print("base added to scene")
        
        let baseBodySize = CGSize(width: 300.0, height: 300.0)
        physicsBody = SKPhysicsBody(rectangleOfSize: baseBodySize)
        physicsBody!.dynamic = false
        
        physicsBody!.categoryBitMask = PhysicsCategory.Base
        physicsBody!.collisionBitMask = PhysicsCategory.Block
    }
}
