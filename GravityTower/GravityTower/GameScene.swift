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
    var tempHasSpawned = false
    var msgHasSpawned = false
    var stars = 0
    
    var tempBlock:FakeBlockNode = FakeBlockNode(imageNamed: "rectangle-fake")
    var currentBlock:BlockNode = BlockNode(imageNamed: "rectangle")
    var allBlocks:[BlockNode] = []
    var goal: GoalNode!
    
    //Levels
    let level1: [String] = ["rectangle", "square", "square", "rectangle", "square", "rectangle", "rectangle", "square", "square", "square"]
    let level1Fake: [String] = ["rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "square-fake", "rectangle-fake", "rectangle-fake", "square-fake", "square-fake", "square-fake"]
    
    let level2: [String] = ["square", "rectangle", "triangle", "triangle", "rectangle", "square", "square", "rectangle", "triangle", "rectangle", "square", "square", "square"]
    let level2Fake: [String] = ["square-fake", "rectangle-fake", "triangle-fake", "triangle-fake", "rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "triangle-fake", "rectangle-fake", "square-fake", "square-fake", "square-fake"]
    
    let level3: [String] = ["triangle", "rectangle", "square", "square", "triangle", "triangle", "square", "rectangle", "rectangle", "square", "square", "rectangle", "triangle"]
    let level3Fake: [String] = ["triangle-fake", "rectangle-fake", "square-fake", "square-fake", "triangle-fake", "triangle-fake", "square-fake", "rectangle-fake", "rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "triangle-fake"]
    
    var counter = 0         // Keep track of the index on level array
    
    // Touched Screen
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        //print("tapped screen")
        
        if (tempBlock.hasBeenSet) {
            //print("spawn real block")

            if (currentLevel == 1){
                currentBlock = BlockNode(imageNamed: level1[counter])
            }
            if (currentLevel == 2){
                currentBlock = BlockNode(imageNamed: level2[counter])
            }
            if (currentLevel == 3){
                currentBlock = BlockNode(imageNamed: level3[counter])
            }
            
            currentBlock.setup(CGPoint(x: tempBlock.position.x, y: tempBlock.position.y), rotation:tempBlock.zRotation, screen: frame)
            allBlocks.append(currentBlock)
            addChild(currentBlock)
            tempBlock.hasBeenSet = false
            tempHasSpawned = false
            tempBlock.removeFromParent()
            
            counter += 1
            
            if (currentLevel == 1 && counter >= level1.count ||
                currentLevel == 2 && counter >= level2.count ||
                currentLevel == 3 && counter >= level3.count){
                counter = 0
            }
        }
        else if playable && currentBlock.position != currentBlock.startPos {
            checkFinished()
        }
    }
    
    func spawnBlock() {
        if !tempHasSpawned {
            tempHasSpawned = true
            //print ("spawn temp block")
            
            if (currentLevel == 1){
                tempBlock = FakeBlockNode(imageNamed: level1Fake[counter])
            }
            else if (currentLevel == 2){
                tempBlock = FakeBlockNode(imageNamed: level2Fake[counter])
            }
            else { // (currentLevel == 3){
                tempBlock = FakeBlockNode(imageNamed: level3Fake[counter])
            }
            
            //tempBlock.zRotation = CGFloat(Int(arc4random()) % 100)
            tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-randomBetweenNumbers(-200, secondNum: 200), y: (self.frame.height - 250.0)), screen: frame)
            addChild(tempBlock)
        }
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
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
        
        // UI
        let quitBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        quitBtn.position = CGPoint(x: 200, y: 100)
        quitBtn.setNormalStateLabelText("Quit")
        quitBtn.setNormalStateLabelFontColor(Constants.Color.White)
        quitBtn.setAllStatesLabelFontName(Constants.Font.Main)
        quitBtn.setAllStatesLabelFontSize(50.0)
        quitBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadMainScene()
        })
        addChild(quitBtn)
        
        // Game Objects
        spawnBlock()
        
        goal = childNodeWithName("//Goal") as! GoalNode
        
        // set up pan gesture recognizer
        let pan = UIPanGestureRecognizer(target: self, action: "panDetected:")
        pan.minimumNumberOfTouches = 1
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        // set up rotate gesture recognizer
        let rotate = UIRotationGestureRecognizer(target: self, action: "rotationDetected:")
        rotate.delegate = self
        view.addGestureRecognizer(rotate)
        
        
        // Background music
        SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    
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
        
        if collision == PhysicsCategory.Block | PhysicsCategory.Base || collision == PhysicsCategory.Block | PhysicsCategory.Block{
            //print("Block landed")
            runAction(SKAction.sequence([
                SKAction.playSoundFileNamed("drop.wav", waitForCompletion: false)
                ]))
            performSelector("checkFinished", withObject: nil, afterDelay: 1)
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Edge {
            //print("Block Fell")
            runAction(SKAction.sequence([
                SKAction.playSoundFileNamed("fall.wav", waitForCompletion: false)
                ]))
            lose()
        }
    }
    
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame)-500)
        addChild(message)
    }
    
    func newGame() {
        view!.presentScene(GameScene.level(currentLevel))
        print("Level \(currentLevel)")
        msgHasSpawned = false
    }
    
    func endGame() {
        print("Finished Game")
        let gameOverScene = GameOverScene(size: self.size)
        self.view?.presentScene(gameOverScene)
        msgHasSpawned = false
    }
    
    func checkFinished() {
        //print("Velocity \(currentBlock.physicsBody?.velocity.dy)")
        if (currentBlock.physicsBody?.velocity.dy < 1 &&
            currentBlock.physicsBody?.velocity.dy > -1 ){
            if currentBlock.position.y >= goal.position.y {
                win()
            } else {
                spawnBlock()
            }
        }
    }
    
    func lose() {
        playable = false
        counter = 0
        
        DefaultsManager.sharedDefaultsManager.setLvlUnlock(currentLevel)
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        runAction(SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false))
        
        inGameMessage("Try again...")
        performSelector("newGame", withObject: nil, afterDelay: 5)
    }
    
    func win() {
        if !msgHasSpawned {
            msgHasSpawned = true
            
            stars++
            
            if (currentLevel == 1 && allBlocks.count <= 3 ||
                currentLevel == 2 && allBlocks.count <= 7 ||
                currentLevel == 3 && allBlocks.count <= 7) {
                    stars++
            }
            
            if (currentLevel == 1 && true ||
                currentLevel == 2 && true ||
                currentLevel == 3 && true) {
                    stars++
            }
            
            var msg = ""
            if stars < 1 {msg = "···"}
            else if stars == 1 {msg = "★··"}
            else if stars == 2 {msg = "★★·"}
            else {msg = "★★★"}
            
            playable = false
            counter = 0
            
            DefaultsManager.sharedDefaultsManager.setLvlUnlock(currentLevel+1)
            DefaultsManager.sharedDefaultsManager.setStars(stars, lvl: currentLevel)
            
            if (currentLevel < 3) {
                currentLevel += 1
            }
            
            SKTAudio.sharedInstance().pauseBackgroundMusic()
            runAction(SKAction.playSoundFileNamed("win.mp3", waitForCompletion: false))
            
            inGameMessage(msg)
            //inGameMessage("Nice job!")
            
            if (currentLevel < 3) {
                performSelector("newGame", withObject: nil, afterDelay: 3)
            } else {
                performSelector("endGame", withObject: nil, afterDelay: 3)
            }
        }
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