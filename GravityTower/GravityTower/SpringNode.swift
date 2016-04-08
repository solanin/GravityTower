//
//  SpringNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class SpringNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
  
  func didMoveToScene() {
    userInteractionEnabled = true
    
  }
  
  func interact() {
    userInteractionEnabled = false
    
    physicsBody!.applyImpulse(CGVector(dx: 0, dy: 250),
      atPoint: CGPoint(x: size.width/2, y: size.height))
    
    runAction(SKAction.sequence([
      SKAction.waitForDuration(1),
      SKAction.removeFromParent()
      ]))
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    interact()
  }

}