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

struct SpriteLayer {
    static let Background   : CGFloat = 0
    static let PlayableRect : CGFloat = 1
    static let HUD          : CGFloat = 2
    static let Sprite       : CGFloat = 3
    static let Message      : CGFloat = 4
}

protocol CustomNodeEvents {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playable = true
    var currentLevel: Int = 0
    
    var base:BaseNode = BaseNode()
    var currentBlock:BlockNode = BlockNode(imageNamed: "block_Rect_Hor")
    var allBlocks:[BlockNode] = []
    
    // Tocuhed Screen
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("tapped screen")

        //spawnBlock()
        
    }
    
    func spawnBlock() {
        let newBlock = FakeBlockNode(imageNamed: "block_Rect_Hor")
        newBlock.setup(CGPoint(x: CGRectGetMidX(self.frame), y: (self.frame.height - 200.0)), screen: frame)
        addChild(newBlock)
    }
    
    /*func spawnBlock() {
        
        currentBlock = BlockNode(imageNamed: "block_Rect_Hor")
        currentBlock.setup(CGPoint(x: CGRectGetMidX(self.frame), y: (self.frame.height - 200.0)), screen: frame)
        allBlocks.append(currentBlock)
        addChild(currentBlock)
    }*/
    
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
        
        // Add background music here
        //SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
        
        base.setup(CGPoint(x: CGRectGetMidX(self.frame), y: base.frame.height/2), screen: frame)
        addChild(base)
        spawnBlock()
    }
    
    /*
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if !playable {
            return
        }
        
        if collision == PhysicsCategory.Block | PhysicsCategory.Base {
            print("Block landed on base")
            spawnBlock()
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Block {
            print("Block landed")
            spawnBlock()
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Edge {
            print("FAIL")
            lose()
        }
        
        
    }*/
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Landed
        if ((firstBody.categoryBitMask & PhysicsCategory.Block != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Base != 0)) {
                if (firstBody.node != nil && secondBody.node != nil) {
                    spawnBlock()
                }
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Block != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Block != 0)) {
                spawnBlock()
        }
        // Fell
        else if ((firstBody.categoryBitMask & PhysicsCategory.Block != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Edge != 0)) {
                lose()
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
        
        performSelector("newGame", withObject: nil, afterDelay: 5)
    }
    
    func win() {
        if (currentLevel < 1) {
            currentLevel += 1
        }
        
        playable = false
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        runAction(SKAction.playSoundFileNamed("win.mp3", waitForCompletion: false))
        
        inGameMessage("Nice job!")
        performSelector("newGame", withObject: nil, afterDelay: 3)
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