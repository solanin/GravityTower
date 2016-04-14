//
//  BlockNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {

    var active: Bool = true

    var isActive: Bool {
        return active
    }
    
    func didMoveToScene() {
        userInteractionEnabled = true
        
        physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        physicsBody!.dynamic = false
        physicsBody!.mass = 20
        
        physicsBody!.categoryBitMask = PhysicsCategory.Block
        physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Base | PhysicsCategory.Edge
    }
    
    func interact() {
        userInteractionEnabled = false
        self.active = false
        physicsBody!.dynamic = true
        
//        runAction(SKAction.sequence([
//            SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
            //SKAction.scaleTo(0.8, duration: 0.1),
            //SKAction.removeFromParent()
//            ]))
        
        print("interact block node")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("touch ended")
        interact()
    }
}