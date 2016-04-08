//
//  CatNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

let kCatTappedNotification = "kCatTappedNotification"

class CatNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
  func didMoveToScene() {
    print("cat added to scene")
    
    let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
    parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catBodyTexture.size())

    parent!.physicsBody!.categoryBitMask = PhysicsCategory.Cat
    parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge | PhysicsCategory.Spring
    parent!.physicsBody!.contactTestBitMask = PhysicsCategory.Bed | PhysicsCategory.Edge
    
    userInteractionEnabled = true
  }
  
  func wakeUp() {
    for child in children {
      child.removeFromParent()
    }
    texture = nil
    color = SKColor.clearColor()

    let catAwake = SKSpriteNode(fileNamed: "CatWakeUp")!.childNodeWithName("cat_awake")!
    
    catAwake.moveToParent(self)
    catAwake.position = CGPoint(x: -30, y: 100)
  }
  
  func curlAt(scenePoint: CGPoint) {
    parent!.physicsBody = nil
    for child in children {
      child.removeFromParent()
    }
    texture = nil
    color = SKColor.clearColor()
    
    let catCurl = SKSpriteNode(fileNamed: "CatCurl")!.childNodeWithName("cat_curl")!
    catCurl.moveToParent(self)
    catCurl.position = CGPoint(x: -30, y: 100)
    
    var localPoint = parent!.convertPoint(scenePoint, fromNode: scene!)
    localPoint.y += frame.size.height/3

    runAction(SKAction.group([
      SKAction.moveTo(localPoint, duration: 0.66),
      SKAction.rotateToAngle(0, duration: 0.5)
      ]))
  }
  
  func interact() {
    NSNotificationCenter.defaultCenter().postNotificationName(
      kCatTappedNotification, object: nil)
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    interact()
  }
}