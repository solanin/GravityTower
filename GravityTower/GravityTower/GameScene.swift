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
    static let Edge:  UInt32 = 0b1 // 1
    static let Block: UInt32 = 0b10 // 2
    static let Base:  UInt32 = 0b100 // 4
    static let Label: UInt32 = 0b1000 // 8
}

protocol CustomNodeEvents {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    var playable = true
    var currentLevel: Int = 0
    var previousPanX:CGFloat = 0.0
    var previousRotation:CGFloat = 0.0
    var blockNode1: BlockNode!
    var blockNode2: BlockNode!
    var blockNode3: BlockNode!
    
    override func didMoveToView(view: SKView) {
        // Calculate playable margin
        
        let maxAspectRatio: CGFloat = 3.0/4.0 // iPad
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
        
//        enumerateChildNodesWithName("block", usingBlock: {node, _ in
//            if let activeBlock = node as? BlockNode {
//                if activeBlock.isActive {
//                    self.blockNode = activeBlock
//                    return
//                }
//            }
//        })
        
        
        blockNode1 = childNodeWithName("block1") as! BlockNode
        blockNode2 = childNodeWithName("block2") as! BlockNode
        blockNode3 = childNodeWithName("block3") as! BlockNode
        
        
        // set up pan gesture recognizer
        let pan = UIPanGestureRecognizer(target: self, action: #selector(GameScene.panDetected(_:)))
        // pan.minimumNumberOfTouches = 2
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        // set up rotate gesture recognizer
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(GameScene.rotationDetected(_:)))
        rotate.delegate = self
        view.addGestureRecognizer(rotate)
        
        // Add background music here
        //SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    }
    
    func panDetected(sender:UIPanGestureRecognizer) {
        // retrieve pan movement along the x-axis of the view since the gesture began
        let currentPanX = sender.translationInView(view!).x
        //print("currentPanX since gesture began = \(currentPanX)")
        
        // calculate deltaX since last measurement
        let deltaX = currentPanX - previousPanX
        
        if (blockNode1.userInteractionEnabled){
            blockNode1.position = CGPointMake(blockNode1.position.x + deltaX, blockNode1.position.y)
        }
        
        if (blockNode2.userInteractionEnabled){
            blockNode2.position = CGPointMake(blockNode2.position.x + deltaX, blockNode2.position.y)
        }
        
        if (blockNode3.userInteractionEnabled){
            blockNode3.position = CGPointMake(blockNode3.position.x + deltaX, blockNode3.position.y)
        }
    
        
        // if the gesture has completed
        if sender.state == .Ended {
            previousPanX = 0
        } else {
            previousPanX = currentPanX
        }
    }
    
    
    func rotationDetected(sender:UIRotationGestureRecognizer){
        // retrieve rotation value since the gesture began
        let currentRotation = sender.rotation
        print("currentRotation (in radians) since gesture began = \(currentRotation)")
        print("velocity = \(sender.velocity)")
        
        // calculate deltaRotation since last measurement
        let deltaRotation = currentRotation - previousRotation
        
        if (blockNode1.isActive){
            blockNode1.zRotation -= deltaRotation
        }
        if (blockNode2.isActive){
            blockNode2.zRotation -= deltaRotation
        }
        if (blockNode3.isActive){
            blockNode3.zRotation -= deltaRotation
        }
        
        
        // if the gesture has completed
        if sender.state == .Ended {
            previousRotation = 0
        } else {
            previousRotation = currentRotation
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if !playable {
            return
        }
        
        if collision == PhysicsCategory.Block | PhysicsCategory.Base {
            print("Block landed")
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Edge {
            print("FAIL")
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
            currentLevel -= 1
        }
        
        playable = false
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        runAction(SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false))
        
        inGameMessage("Try again...")
        
        performSelector(#selector(GameScene.newGame), withObject: nil, afterDelay: 5)
    }
    
    func win() {
//        if (currentLevel < 1) {
//            currentLevel += 1
//        }
        
        playable = false
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        runAction(SKAction.playSoundFileNamed("win.mp3", waitForCompletion: false))
        
        inGameMessage("Nice job!")
        performSelector(#selector(GameScene.newGame), withObject: nil, afterDelay: 3)
    }
    
    override func didSimulatePhysics() {
        if playable {
            // if physics on tower make it fall, lose
            
            //      if fabs(catNode.parent!.zRotation) > CGFloat(25).degreesToRadians() {
            //        lose()
            //      }
        }
        
    }
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        scene.scaleMode = .AspectFill
        return scene
    }
    
    
}