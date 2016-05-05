//
//  ZenGameScene.swift
//  GravityTower
//
//  Created by igmstudent on 5/2/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

//
//  GameScene.swift

import SpriteKit

class ZenGameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Variables
    
    var playable = true
    var currentLevel: Int = 0
    var previousPanX:CGFloat = 0.0
    var previousRotation:CGFloat = 0.0
    var tempHasSpawned = false
    var msgHasSpawned = false
    
    let results: LevelResults = LevelResults(level: 0, score: 0, numBlocks: 0)
    
    // UI
    let levelLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    let scoreLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    
    var tempBlock:FakeBlockNode = FakeBlockNode(imageNamed: "rectangle-fake")
    var currentBlock:BlockNode = BlockNode(imageNamed: "rectangle")
    var allBlocks:[BlockNode] = []
    
    //Source
    let shapes: [String] = ["rectangle", "rectangle", "hexagon", "square", "square", "triangle"]
    let shapesFake: [String] = ["rectangle-fake", "rectangle-fake", "hexagon-fake", "square-fake", "square", "triangle-fake"]
    
    var currentIndex = 0;
    
    //MARK: Spawn real block from the fake block
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if !playable{
            return
        }
        
        if (tempBlock.hasBeenSet) {
            
            currentBlock = BlockNode(imageNamed: shapes[currentIndex])
            
            currentBlock.setup(CGPoint(x: tempBlock.position.x, y: tempBlock.position.y), rotation:tempBlock.zRotation, screen: frame)
            allBlocks.append(currentBlock)
            addChild(currentBlock)
            scoreLabel.text = "Blocks: \(allBlocks.count)"
            tempBlock.hasBeenSet = false
            tempHasSpawned = false
            tempBlock.removeFromParent()
        }
        else if playable && currentBlock.position != currentBlock.startPos {
            checkFinished()
        }
    }
    
    //MARK: Set up temporary block in stage mode
    func spawnBlock() {
        if !playable{
            return
        }
        
        if !tempHasSpawned { // Spawn temporary block
            tempHasSpawned = true
            
            currentIndex = Int(arc4random_uniform(6)); // randomBetweenNumbers
            tempBlock = FakeBlockNode(imageNamed: shapesFake[currentIndex])
            
            //tempBlock.zRotation = CGFloat(Int(arc4random()) % 80)
            tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-randomBetweenNumbers(-200, secondNum: 200), y: (self.frame.height - 250.0)), screen: frame)
            addChild(tempBlock)
        }
    }
    
    
    // MARK: User Interaction Functions
    
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
        let quitBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Green, highlightedColor: Constants.Color.Blue)
        
        quitBtn.position = CGPoint(x: CGRectGetMinX(self.frame)+320, y: CGRectGetMaxY(self.frame)-100)
        quitBtn.setNormalStateLabelText("Quit")
        quitBtn.setNormalStateLabelFontColor(Constants.Color.White)
        quitBtn.setAllStatesLabelFontName(Constants.Font.Main)
        quitBtn.setAllStatesLabelFontSize(50.0)
        quitBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadMainScene()
        })
        addChild(quitBtn)
        
        //Level label
        levelLabel.text = "Zen Mode"
        levelLabel.fontSize = 60
        levelLabel.verticalAlignmentMode = .Center
        levelLabel.horizontalAlignmentMode = .Right
        levelLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-250, y:CGRectGetMaxY(self.frame)-100)
        self.addChild(levelLabel)
        
        //Score label
        scoreLabel.text = "Blocks: \(results.numBlocks)"
        scoreLabel.fontSize = 50
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-250, y:CGRectGetMaxY(self.frame)-180)
        self.addChild(scoreLabel)
        
        
        // Game Objects
        spawnBlock()
        
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
        let currentPanX = sender.translationInView(view).x
        
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
            //Block landed
            runAction(SKAction.sequence([
                SKAction.playSoundFileNamed("drop.wav", waitForCompletion: false)
                ]))
            performSelector("checkFinished", withObject: nil, afterDelay: 1)
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Edge {
            //Block Fell
            runAction(SKAction.sequence([
                SKAction.playSoundFileNamed("fall.wav", waitForCompletion: false)
                ]))
            results.numBlocks = allBlocks.count-1
            scoreLabel.text = "Blocks: \(results.numBlocks)"
            lose()
        }
    }
    
    
    // MARK: End game functions
    
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame)-400)
        addChild(message)
    }
    
    func endGame() {
        //print("Finished Game")
        let gameOverScene = ZenGameOverScene(size: self.size, results: results)
        self.view?.presentScene(gameOverScene)
        msgHasSpawned = false
    }
    
    func checkFinished() {
        if (currentBlock.physicsBody?.velocity.dy < 1 &&
            currentBlock.physicsBody?.velocity.dy > -1 ){
                spawnBlock()
        }
    }
    
    //MARK: Lose conditions
    func lose() {
        playable = false
        
        runAction(SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false))
        
        results.numBlocks = allBlocks.count - 1
        inGameMessage("Total: \(results.numBlocks)")
        
        performSelector("endGame", withObject: nil, afterDelay: 5)
    }
    
    //MARK: Pause Actions
    var gameLoopPaused:Bool = true {
        didSet{
            //print("gameLoopPaused=\(gameLoopPaused)")
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
    
    //MARK: SKS Loading
    class func loadSKSFile() -> ZenGameScene? {
        let scene = ZenGameScene(fileNamed: "Empty")!
        print("SETUP Zen LEVEL")
        scene.scaleMode = .AspectFill
        return scene
    }
}