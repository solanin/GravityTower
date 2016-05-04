//
//  GameScene.swift
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Variables
    
    var playable = true
    var currentLevel: Int = 0
    var previousPanX:CGFloat = 0.0
    var previousRotation:CGFloat = 0.0
    var tempHasSpawned = false
    var msgHasSpawned = false
    var stars = 0
    let LAST_LEVEL = 5
    var START_POINT:CGFloat = 0.0
    
    // UI
    let levelLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    let scoreLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    let tipLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    
    var tempBlock:FakeBlockNode = FakeBlockNode(imageNamed: "rectangle-fake")
    var currentBlock:BlockNode = BlockNode(imageNamed: "rectangle")
    var allBlocks:[BlockNode] = []
    var goal: GoalNode!
    
    //Levels
    let starCuttoff: [Int] = [2, 3, 7, 6]
    
    let level1: [String] = ["square", "rectangle", "triangle"]
    let level1Fake: [String] = ["square-fake","rectangle-fake", "triangle-fake"]
    
    let level2: [String] = ["rectangle", "square", "square", "rectangle", "square", "rectangle", "rectangle", "square", "square", "square"]
    let level2Fake: [String] = ["rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "square-fake", "rectangle-fake", "rectangle-fake", "square-fake", "square-fake", "square-fake"]
    
    let level3: [String] = ["square", "rectangle", "triangle", "triangle", "rectangle", "square", "square", "rectangle", "triangle", "rectangle", "square", "square", "square"]
    let level3Fake: [String] = ["square-fake", "rectangle-fake", "triangle-fake", "triangle-fake", "rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "triangle-fake", "rectangle-fake", "square-fake", "square-fake", "square-fake"]
    
    let level4: [String] = ["rectangle", "hexagon", "hexagon", "square", "rectangle", "square", "hexagon", "rectangle", "square", "square", "rectangle", "hexagon", "triangle"]
    let level4Fake: [String] = ["rectangle-fake", "hexagon-fake", "hexagon-fake", "square-fake", "rectangle-fake", "square-fake", "hexagon-fake", "rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "hexagon-fake", "triangle-fake"]
    
    var counter = 0         // Keep track of the index on level array
    
    //MARK: Spawn real block from the fake block
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        print("\(currentLevel) : \(allBlocks.count) / \(starCuttoff[currentLevel-1])")
        
        if !playable{
            return
        }
        
        if (tempBlock.hasBeenSet) {
            
            switch (currentLevel) {
            case 1:
                currentBlock = BlockNode(imageNamed: level1[counter])
            case 2:
                currentBlock = BlockNode(imageNamed: level2[counter])
            case 3:
                currentBlock = BlockNode(imageNamed: level3[counter])
            case 4:
                currentBlock = BlockNode(imageNamed: level4[counter])
            default:
                currentBlock = BlockNode(imageNamed: "square")
            }
    
            currentBlock.setup(CGPoint(x: tempBlock.position.x, y: tempBlock.position.y), rotation:tempBlock.zRotation, screen: frame)
            allBlocks.append(currentBlock)
            addChild(currentBlock)
            tempBlock.hasBeenSet = false
            tempHasSpawned = false
            tempBlock.removeFromParent()
            
            counter += 1
            
            if (currentLevel == 1 && counter == 1) {
                tipLabel.text = "Tap and drag to slide block"
            } else if (currentLevel == 1 && counter == 2) {
                tipLabel.text = "Use two fingers to rotate"
            }
            
            
            if (currentLevel == 1 && counter >= level1.count ||
                currentLevel == 2 && counter >= level2.count ||
                currentLevel == 3 && counter >= level3.count ||
                currentLevel == 4 && counter >= level4.count) {
                counter = 0
            }
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
            
            switch (currentLevel) {
            case 1:
                tempBlock = FakeBlockNode(imageNamed: level1Fake[counter])
            case 2:
                tempBlock = FakeBlockNode(imageNamed: level2Fake[counter])
            case 3:
                tempBlock = FakeBlockNode(imageNamed: level3Fake[counter])
            case 4:
                tempBlock = FakeBlockNode(imageNamed: level4Fake[counter])
            default:
                tempBlock = FakeBlockNode(imageNamed: "square-fake")
            }
            
            // Set Up Onboarding
            if (currentLevel == 1) {
                switch (counter) {
                case 0:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame), y: START_POINT), screen: frame)
                case 1:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-300, y: START_POINT), screen: frame)
                case 2:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame), y: START_POINT), screen: frame)
                    tempBlock.zRotation = CGFloat(M_PI)
                default:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-randomBetweenNumbers(-200, secondNum: 200), y: START_POINT), screen: frame)
                }
            } else {
                tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-randomBetweenNumbers(-200, secondNum: 200), y: START_POINT), screen: frame)
            }
            
            
            addChild(tempBlock)
        }
    }
    
    //MARK: User Interaction Functions
    
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
        levelLabel.text = "Level \(self.currentLevel)"
        levelLabel.fontSize = 60
        levelLabel.verticalAlignmentMode = .Center
        levelLabel.horizontalAlignmentMode = .Right
        levelLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-100, y:CGRectGetMaxY(self.frame)-100)
        self.addChild(levelLabel)
        
        //Score label
        scoreLabel.text = "★★★"
        scoreLabel.fontSize = 50
        scoreLabel.verticalAlignmentMode = .Center
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-100, y:CGRectGetMaxY(self.frame)-180)
        self.addChild(scoreLabel)
        
        
        //Tip label
        if (currentLevel == 1) {
            tipLabel.text = "Tap to drop block"
            tipLabel.fontSize = 80
            tipLabel.verticalAlignmentMode = .Center
            tipLabel.horizontalAlignmentMode = .Center
            tipLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 300)
            self.addChild(tipLabel)
        }
        
        
        // set up goal line
        goal = childNodeWithName("//Goal") as! GoalNode
        
        START_POINT = goal.position.y + 300.0
        
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
            lose()
        }
    }
    
    // MARK: End game functions
    
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame)-400)
        addChild(message)
    }
    
    func newGame() {
        view?.presentScene(GameScene.level(currentLevel))
        print("LOADING Level \(currentLevel)")
        self.levelLabel.text = "Level \(self.currentLevel)"
        msgHasSpawned = false
    }
    
    func endGame() {
        //print("Finished Game")
        let gameOverScene = GameOverScene(size: self.size)
        self.view?.presentScene(gameOverScene)
        msgHasSpawned = false
    }
    
    func checkFinished() {
        if (currentBlock.physicsBody?.velocity.dy < 1 &&
            currentBlock.physicsBody?.velocity.dy > -1 ){
            if currentBlock.position.y >= goal.position.y {
                win()
            } else {
                spawnBlock()
            }
        }
    }
    
    //MARK: Lose conditions
    func lose() {
        playable = false
        counter = 0
        
        DefaultsManager.sharedDefaultsManager.setLvlUnlock(currentLevel)
        print("SAVING for LEVEL \(currentLevel) : unlocked lvl \(currentLevel) / and earned \(stars) stars")
        
        SKTAudio.sharedInstance().playSoundEffect("lose.wav")
        
        inGameMessage("Try again...")
        performSelector("newGame", withObject: nil, afterDelay: 5)
    }
    
    //MARK: Win conditions
    func win() {
        if !msgHasSpawned {
            msgHasSpawned = true
            
            // Star for winning
            stars += 1
            
            // Star for using min amt of blocks
            if (allBlocks.count < starCuttoff[currentLevel-1]) {
                stars += 1
            }
            
            // Star for ???
            if (currentLevel == 1 && true ||
                currentLevel == 2 && true ||
                currentLevel == 3 && true ||
                currentLevel == 4 && true) {
                stars += 1
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
            print("SAVING for LEVEL \(currentLevel) : unlocked lvl \(currentLevel+1) / and earned \(stars) stars")

            runAction(SKAction.playSoundFileNamed("win.wav", waitForCompletion: false))
            
            inGameMessage(msg)
            
            //INCREASE LEVEL
            currentLevel += 1
            
            if (currentLevel < LAST_LEVEL) {
                performSelector("newGame", withObject: nil, afterDelay: 3)
            } else {
                performSelector("endGame", withObject: nil, afterDelay: 3)
            }
        }
    }
    
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
        print("SETUP Level \(levelNum)")
        scene.scaleMode = .AspectFill
        return scene
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
}