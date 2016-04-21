//
//  BaseNode.swift
//  GravityTower
//
//  Created by igmstudent on 4/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit

class BaseNode: SKSpriteNode {
    
    func didMoveToScene() {
        print("base added to scene")
        
        let baseBodySize = CGSize(width: 300.0, height: 300.0)
        physicsBody! = SKPhysicsBody(rectangleOfSize: baseBodySize)
        
        physicsBody!.dynamic = false
        physicsBody!.allowsRotation = false
        physicsBody!.mass = 100
        
        physicsBody!.categoryBitMask = PhysicsCategory.Base
        physicsBody!.contactTestBitMask = PhysicsCategory.Block
        physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge
        zPosition = SpriteLayer.Sprite
    }
}
