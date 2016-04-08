//
//  GameScene.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
  static let None:  UInt32 = 0
  static let Cat:   UInt32 = 0b1 // 1
  static let Block: UInt32 = 0b10 // 2
  static let Bed:   UInt32 = 0b100 // 4
  static let Edge:  UInt32 = 0b1000 // 8
  static let Label: UInt32 = 0b10000 // 16
  static let Spring:UInt32 = 0b100000 // 32
  static let Hook:  UInt32 = 0b1000000 // 64
}

protocol CustomNodeEvents {
  func didMoveToScene()
}

protocol InteractiveNode {
  func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
  
  var bedNode: BedNode!
  var catNode: CatNode!
  
  var playable = true
  var currentLevel: Int = 0
  
  var hookNode: HookNode?
  
  override func didMoveToView(view: SKView) {
    // Calculate playable margin
    
    let maxAspectRatio: CGFloat = 16.0/9.0 // iPhone 5
    let maxAspectRatioHeight = size.width / maxAspectRatio
    let playableMargin: CGFloat = (size.height - maxAspectRatioHeight)/2
    
    let playableRect = CGRect(x: 0, y: playableMargin,
      width: size.width, height: size.height-playableMargin*2)
    
    physicsBody = SKPhysicsBody(edgeLoopFromRect: playableRect)
    physicsWorld.contactDelegate = self
    physicsBody!.categoryBitMask = PhysicsCategory.Edge
    
    enumerateChildNodesWithName("//*", usingBlock: {node, _ in
      if let customNode = node as? CustomNodeEvents {
        customNode.didMoveToScene()
      }
    })
    
    bedNode = childNodeWithName("bed") as! BedNode
    catNode = childNodeWithName("//cat_body") as! CatNode
    
//    bedNode.setScale(1.5)
//    catNode.setScale(1.5)

    SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    
    hookNode = childNodeWithName("hookBase") as? HookNode
  }
  
  func didBeginContact(contact: SKPhysicsContact) {
    //chapter 10 challenge 1
    let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

    if collision == PhysicsCategory.Label | PhysicsCategory.Edge {
      
      let labelNode = (contact.bodyA.categoryBitMask == PhysicsCategory.Label) ?
        contact.bodyA.node :
        contact.bodyB.node
      
      if let message = labelNode as? MessageNode {
        message.didBounce()
      }
    }

    if !playable {
      return
    }
    
    if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
      print("SUCCESS")
      win()
    } else if collision == PhysicsCategory.Cat | PhysicsCategory.Edge {
      print("FAIL")
      lose()
    }
    
    if collision == PhysicsCategory.Cat | PhysicsCategory.Hook && hookNode?.isHooked == false {
      hookNode!.hookCat(catNode)
    }
  }
  
  func inGameMessage(text: String) {
    let message = MessageNode(message: text)
    message.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
    addChild(message)
  }
  
  func newGame() {
    view!.presentScene(GameScene.level(currentLevel))
  }

  func lose() {
    if (currentLevel > 1) {
      currentLevel--
    }

    playable = false
    
    SKTAudio.sharedInstance().pauseBackgroundMusic()
    runAction(SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false))
    
    inGameMessage("Try again...")
    
    performSelector("newGame", withObject: nil, afterDelay: 5)
    
    catNode.wakeUp()
  }

  func win() {
    if (currentLevel < 4) {
      currentLevel++
    }

    playable = false
    
    SKTAudio.sharedInstance().pauseBackgroundMusic()
    runAction(SKAction.playSoundFileNamed("win.mp3", waitForCompletion: false))
    
    inGameMessage("Nice job!")
    
    performSelector("newGame", withObject: nil, afterDelay: 3)
    
    catNode.curlAt(bedNode.position)
  }

  override func didSimulatePhysics() {
    if playable && hookNode?.isHooked != true {
      if fabs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
        lose()
      }
    }
    
  }
  
  class func level(levelNum: Int) -> GameScene? {
    let scene = GameScene(fileNamed: "Level\(levelNum)")!
    scene.currentLevel = levelNum
    scene.scaleMode = .AspectFill
    return scene
  }

}