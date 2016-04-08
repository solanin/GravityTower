//
//  StoneNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class StoneNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
  
  func didMoveToScene() {
    let levelScene = scene
    
    if parent == levelScene {
      levelScene!.addChild(StoneNode.makeCompoundNode(inScene: levelScene!))
    }
  }
  
  func interact() {
    userInteractionEnabled = false
    
    runAction( SKAction.sequence([
      SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
      SKAction.removeFromParent()
      ]))
  }
  
  static func makeCompoundNode(inScene scene: SKScene) -> SKNode {
    let compound = StoneNode()
    compound.zPosition = -1

    for stone in scene.children.filter({node in node is StoneNode}) {
      stone.removeFromParent()
      compound.addChild(stone)
    }

    let bodies = compound.children.map({node in
      SKPhysicsBody(rectangleOfSize: node.frame.size, center: node.position)
    })

    compound.physicsBody = SKPhysicsBody(bodies: bodies)
    compound.physicsBody!.collisionBitMask = PhysicsCategory.Edge | PhysicsCategory.Cat | PhysicsCategory.Block
    compound.physicsBody!.categoryBitMask = PhysicsCategory.Block
    compound.userInteractionEnabled = true
    compound.zPosition = 1
    
    return compound
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    interact()
  }
}

