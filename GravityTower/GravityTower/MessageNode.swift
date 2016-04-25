//
//  MessageNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class MessageNode: SKLabelNode {
  
  convenience init(message: String) {
    
    self.init(fontNamed: Constants.Font.Main)
    
    text = message
    fontSize = 200
    fontColor = SKColor.grayColor()
    zPosition = 100
    
    let front = SKLabelNode(fontNamed: Constants.Font.Main)
    front.text = message
    front.fontSize = 200
    front.fontColor = SKColor.whiteColor()
    front.position = CGPoint(x: -2, y: -2)
    addChild(front)
   
    physicsBody = SKPhysicsBody(circleOfRadius: 10)
    physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Goal
    physicsBody!.contactTestBitMask = PhysicsCategory.Edge | PhysicsCategory.Goal
    physicsBody!.categoryBitMask = PhysicsCategory.Label
    physicsBody!.restitution = 0.7
  }
  
  //chapter 10 challenge 1
  private var bounceCount = 0
  
  func didBounce() {
    if ++bounceCount >= 4 {
      removeFromParent()
    }
  }
}
