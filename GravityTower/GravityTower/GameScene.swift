//
//  GameScene.swift
//  GravityTower
//
//  Created by igmstudent on 5/5/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Variables
    
    // Game Var
    var results: LevelResults = LevelResults(level: 0, stars: 0, numBlocks: 0)
    var playable = true
    var previousPanX:CGFloat = 0.0
    var previousRotation:CGFloat = 0.0
    var tempHasSpawned = false
    var msgHasSpawned = false
    
    // UI
    let levelLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    let scoreLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    
    var nextBlock:FakeBlockNode = FakeBlockNode(imageNamed: "rectangle-fake")
    var tempBlock:FakeBlockNode = FakeBlockNode(imageNamed: "rectangle-fake")
    var currentBlock:BlockNode = BlockNode(imageNamed: "rectangle")
    var allBlocks:[BlockNode] = []
    
    var hero:HeroNode?
    let theCamera: SKCameraNode = SKCameraNode()
    
    // Levels
    var shapes: [String] = []
    var currentIndex = 0;
    var nextIndex = -1;
    
    // MARK: Start Game Functions
    override func didMoveToView(view: SKView) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            maxAspectRatio = 3.0/4.0 // iPad
        } else {
            maxAspectRatio = 9.0/16.0 // iPhone
        }
        
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
        
        //        self.camera = theCamera
        //        self.anchorPoint = CGPoint(x: 0, y: 0)
        //        self.addChild(theCamera)
        //        theCamera.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        //
        //        hero = childNodeWithName("hero") as? HeroNode
        //        hero?.setup(CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)))
        
        
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
        levelLabel.text = "Level \(results.level)"
        levelLabel.fontSize = 60
        levelLabel.verticalAlignmentMode = .Center
        levelLabel.horizontalAlignmentMode = .Right
        levelLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-250, y:CGRectGetMaxY(self.frame)-100)
        self.addChild(levelLabel)
        
        //Score label
        scoreLabel.text = formatStars(results.stars)
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
    
    override func update(currentTime: CFTimeInterval) {
        //        let action = SKAction.moveTo((hero?.position)!, duration: 0.25)
        //        if (hero?.position.y < goalLine?.position.y){
        //            theCamera.runAction(action)
        //            print("pass hero, move camera")
        //        }
    }
    
    // MARK: Spawn Functions
    
    // Spawns the Real Block
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if !playable{
            return
        }
        
        if (tempBlock.hasBeenSet) {
            currentBlock = BlockNode(imageNamed: shapes[currentIndex])
            
            currentBlock.setup(CGPoint(x: tempBlock.position.x, y: tempBlock.position.y), rotation:tempBlock.zRotation, screen: frame)
            
            shapeSize("current")
            
            allBlocks.append(currentBlock)
            addChild(currentBlock)
            
            tempBlock.hasBeenSet = false
            tempHasSpawned = false
            tempBlock.removeFromParent()
            nextBlock.removeFromParent()
            
            calcShowScore()
        }
        else if playable && currentBlock.position != currentBlock.startPos {
            shapeSize("current")
            checkFinished()
            
            //hero?.position = currentBlock.position
        }
        
        //hero?.position = currentBlock.position
        
    }
    
    func calcShowScore () {
        results.numBlocks = allBlocks.count
        scoreLabel.text = "Blocks: \(results.numBlocks)"
    }
    
    // Set up temporary block
    func spawnBlock() {
        if !playable{
            return
        }
        
        
        if !tempHasSpawned { // Spawn temporary block
            tempHasSpawned = true
            
            if (nextIndex == -1 || (currentIndex > shapes.count || currentIndex < 0)) {
                currentIndex = Int(arc4random_uniform(UInt32(shapes.count))); // randomBetweenNumbers
                nextIndex = Int(arc4random_uniform(UInt32(shapes.count))); // randomBetweenNumbers
            } else {
                currentIndex = nextIndex
                nextIndex = Int(arc4random_uniform(UInt32(shapes.count))); // randomBetweenNumbers
            }
            
            tempBlock = FakeBlockNode(imageNamed: shapes[currentIndex]+"-fake")
            
            
            //tempBlock.zRotation = CGFloat(Int(arc4random()) % 80)
            tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-randomBetweenNumbers(-200, secondNum: 200), y: (self.frame.height - 250.0)), screen: frame)
            
            shapeSize("temp")
            
            addChild(tempBlock)
            
            spawnNextBlock()
        }
    }
    
    // Spawns the temporary "next" icon block
    func spawnNextBlock() {
        nextBlock = FakeBlockNode(imageNamed: shapes[nextIndex]+"-fake")
        
        nextBlock.setup(CGPoint(x:CGRectGetMaxX(self.frame)-290, y:CGRectGetMaxY(self.frame)-260), screen: frame)
        nextBlock.setScale(0.25)
        
        addChild(nextBlock)
    }
    
    // MARK: Collision
    func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if !playable {
            return
        }
        
        if collision == PhysicsCategory.Block | PhysicsCategory.Base || collision == PhysicsCategory.Block | PhysicsCategory.Block{
            //Block landed
            shapeSize("current")
            runAction(SKAction.sequence([
                SKAction.playSoundFileNamed("drop.wav", waitForCompletion: false)
                ]))
            
            performSelector("checkFinished", withObject: nil, afterDelay: 1)
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Edge {
            //Block Fell
            blockFell()
        }
    }
    
    func blockFell() {
        runAction(SKAction.sequence([
            SKAction.playSoundFileNamed("fall.wav", waitForCompletion: false)
            ]))
        results.numBlocks = allBlocks.count - 1
        scoreLabel.text = "Blocks: \(results.numBlocks)"
        lose()
    }
    
    // MARK: End Game Functions
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame)-400)
        addChild(message)
    }
    
    func endGame() {
        //print("Finished Game")
        let gameOverScene = GameOverScene(size: self.size, results: results)
        self.view?.presentScene(gameOverScene)
        msgHasSpawned = false
    }
    
    func checkFinished() {
        if (currentBlock.physicsBody?.velocity.dy < 1 &&
            currentBlock.physicsBody?.velocity.dy > -1 ){
            spawnBlock()
        }
    }
    
    func lose() {
        playable = false
        
        runAction(SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false))
        
        save()
        
        inGameMessage("Total: \(results.numBlocks)")
        performSelector("endGame", withObject: nil, afterDelay: 5)
    }
    
    func save () {
        print("SAVING")
    }
    
    //MARK: Gestures
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
    
    //MARK: Decrease Shape size based on level
    func shapeSize(block: String){
        if (self.results.level == 5){
            if (block == "temp") {
                currentBlock.setScale(0.8)
            }
            if (block == "current") {
                currentBlock.setScale(0.8)
            }
        }
        if (self.results.level == 6){
            if (block == "temp") {
                tempBlock.setScale(0.7)
            }
            if (block == "current") {
                currentBlock.setScale(0.7)
            }
        }
        if (self.results.level == -1){
            if (block == "temp") {
                tempBlock.setScale(0.85)
            }
            if (block == "current") {
                currentBlock.setScale(0.85)
            }
        }
    }
}