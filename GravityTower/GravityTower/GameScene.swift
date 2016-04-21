//
//  GameScene.swift
//  
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
    static let Goal:  UInt32 = 0b10000 // 16
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

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    var playable = true
    var currentLevel: Int = 0
    var previousPanX:CGFloat = 0.0
    var previousRotation:CGFloat = 0.0
    var readyForNext = true
    
    var tempBlock:FakeBlockNode = FakeBlockNode(imageNamed: "block_Rect_Hor_Temp")
    var base:BaseNode = BaseNode()
    var currentBlock:BlockNode = BlockNode(imageNamed: "block_Rect_Hor")
    var allBlocks:[BlockNode] = []
    var goal: GoalNode = GoalNode(imageNamed: "line")
    
    // Touched Screen
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("tapped screen")
        
        if (tempBlock.hasBeenSet) {
            print("spawn real block")
            currentBlock = BlockNode(imageNamed: "block_Rect_Hor")
            currentBlock.setup(CGPoint(x: tempBlock.position.x, y: tempBlock.position.y), rotation:tempBlock.zRotation, screen: frame)
            allBlocks.append(currentBlock)
            addChild(currentBlock)
            tempBlock.hasBeenSet = false
            tempBlock.removeFromParent()
        }
        else {
            checkFinished()
        }
    }
    
    func spawnBlock() {
        readyForNext = false
        print ("spawn temp block")
        tempBlock = FakeBlockNode(imageNamed: "block_Rect_Hor_Temp")
        tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame), y: (self.frame.height - 200.0)), screen: frame)
        addChild(tempBlock)
    }
    
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
        
        base.setup(CGPoint(x: CGRectGetMidX(self.frame), y: base.frame.height/2), screen: frame)
        addChild(base)
        spawnBlock()
        
        goal.setup(CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)), screen: frame)
        addChild(goal)
        
        
        // set up pan gesture recognizer
        let pan = UIPanGestureRecognizer(target: self, action: "panDetected:")
        pan.minimumNumberOfTouches = 2
        pan.delegate = self
        //view.addGestureRecognizer(pan)
        
        // set up rotate gesture recognizer
        let rotate = UIRotationGestureRecognizer(target: self, action: "rotationDetected:")
        rotate.delegate = self
        //view.addGestureRecognizer(rotate)
        
        
        // Add background music here
        //SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
        
        gameLoopPaused = true
        gameLoopPaused = false
    }
    
    func panDetected(sender:UIPanGestureRecognizer) {
        // retrieve pan movement along the x-axis of the view since the gesture began
        let currentPanX = sender.translationInView(view!).x
        //print("currentPanX since gesture began = \(currentPanX)")
        
        // calculate deltaX since last measurement
        let deltaX = currentPanX - previousPanX
    
        tempBlock.position = CGPointMake(tempBlock.position.x + deltaX, tempBlock.position.y)
        
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
    
        tempBlock.zRotation -= deltaRotation
        
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
            print("Block landed on base")
            checkFinished()
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Block {
            print("Block landed")
            checkFinished()
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Edge {
            print("Block Fell")
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
    
    func checkFinished() {
        print("Velocity \(currentBlock.physicsBody?.velocity.dy)")
        if (currentBlock.physicsBody?.velocity.dy < 15 &&
            currentBlock.physicsBody?.velocity.dy > -15 ){
            if currentBlock.position.y >= goal.position.y {
                win()
            } else {
                spawnBlock()
            }
        }
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
    
    var gameLoopPaused:Bool = true {
        didSet{
            print("gameLoopPaused=\(gameLoopPaused)")
            if gameLoopPaused {
                runPauseAction()
            } else {
                runUnpauseAction()
            }
        }
    }
    
    func runUnpauseAction() {
        self.view?.paused = false
        let unPauseAction = SKAction.sequence([
            SKAction.fadeInWithDuration(1.5),
            SKAction.runBlock({
                self.physicsWorld.speed = 1.0
            })
        ])
        unPauseAction.timingMode = .EaseIn
        runAction(unPauseAction)
    }
    
    func runPauseAction(){
        scene?.alpha = 0.50
        physicsWorld.speed = 0.0
        self.view?.paused = true
    }
}