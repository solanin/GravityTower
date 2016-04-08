//
//  BlockNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
  func didMoveToScene() {
    userInteractionEnabled = true
  }
  
  func interact() {
    userInteractionEnabled = false
    
    runAction(SKAction.sequence([
      SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
      SKAction.scaleTo(0.8, duration: 0.1),
      SKAction.removeFromParent()
      ]))
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    print("destroy block")
    interact()
  }
}