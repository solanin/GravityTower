//
//  GameScene.swift

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    var playable = true
    var currentLevel: Int = 0
    var previousPanX:CGFloat = 0.0
    var previousRotation:CGFloat = 0.0
    var tempHasSpawned = false
    var msgHasSpawned = false
    var stars = 0
    let levelLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    
    var tempBlock:FakeBlockNode = FakeBlockNode(imageNamed: "rectangle-fake")
    var currentBlock:BlockNode = BlockNode(imageNamed: "rectangle")
    var allBlocks:[BlockNode] = []
    var goal: GoalNode!
    
    //Levels
    let level1: [String] = ["rectangle", "square", "square", "rectangle", "square", "rectangle", "rectangle", "square", "square", "square"]
    let level1Fake: [String] = ["rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "square-fake", "rectangle-fake", "rectangle-fake", "square-fake", "square-fake", "square-fake"]
    
    let level2: [String] = ["square", "rectangle", "triangle", "triangle", "rectangle", "square", "square", "rectangle", "triangle", "rectangle", "square", "square", "square"]
    let level2Fake: [String] = ["square-fake", "rectangle-fake", "triangle-fake", "triangle-fake", "rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "triangle-fake", "rectangle-fake", "square-fake", "square-fake", "square-fake"]
    
    let level3: [String] = ["rectangle", "hexagon", "hexagon", "square", "rectangle", "square", "hexagon", "rectangle", "square", "square", "rectangle", "hexagon", "triangle"]
    let level3Fake: [String] = ["rectangle-fake", "hexagon-fake", "hexagon-fake", "square-fake", "rectangle-fake", "square-fake", "hexagon-fake", "rectangle-fake", "square-fake", "square-fake", "rectangle-fake", "hexagon-fake", "triangle-fake"]
    
    var counter = 0         // Keep track of the index on level array
    
    //MARK: Spawn real block from the fake block
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        if !playable{
            return
        }
        
        if (tempBlock.hasBeenSet) {
            
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
    
    //MARK: Set up temporary block in stage mode
    func spawnBlock() {
        if !playable{
            return
        }
        
        if !tempHasSpawned { // Spawn temporary block
            tempHasSpawned = true
            
            if (currentLevel == 1){
                tempBlock = FakeBlockNode(imageNamed: level1Fake[counter])
            }
            else if (currentLevel == 2){
                tempBlock = FakeBlockNode(imageNamed: level2Fake[counter])
            }
            else { // (currentLevel == 3){
                tempBlock = FakeBlockNode(imageNamed: level3Fake[counter])
            }
            
            //tempBlock.zRotation = CGFloat(Int(arc4random()) % 80)
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
        let quitBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Green, highlightedColor: Constants.Color.Blue)
        
        quitBtn.position = CGPoint(x: CGRectGetMinX(self.frame)+200, y: CGRectGetMaxY(self.frame)-100)
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
        levelLabel.fontSize = 80
        levelLabel.verticalAlignmentMode = .Center
        levelLabel.horizontalAlignmentMode = .Right
        levelLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-100, y:CGRectGetMaxY(self.frame)-100)
        self.addChild(levelLabel)
        
        
        // Game Objects
        spawnBlock()
        
        // set up goal line
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
    
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame)-400)
        addChild(message)
    }
    
    func newGame() {
        view?.presentScene(GameScene.level(currentLevel))
        //print("Level \(currentLevel)")
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
        
        SKTAudio.sharedInstance().playSoundEffect("lose.wav")
        
        inGameMessage("Try again...")
        performSelector("newGame", withObject: nil, afterDelay: 5)
    }
    
    //MARK: Win conditions
    func win() {
        if !msgHasSpawned {
            msgHasSpawned = true
            
            stars += 1
            
            if (currentLevel == 1 && allBlocks.count <= 3 ||
                currentLevel == 2 && allBlocks.count <= 7 ||
                currentLevel == 3 && allBlocks.count <= 6) {
                stars += 1
            }
            
            if (currentLevel == 1 && true ||
                currentLevel == 2 && true ||
                currentLevel == 3 && true) {
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
            
            if (currentLevel < 3) {
                currentLevel += 1
            }
            
            runAction(SKAction.playSoundFileNamed("win.wav", waitForCompletion: false))
            
            inGameMessage(msg)
            
            if (currentLevel < 4) {
                performSelector("newGame", withObject: nil, afterDelay: 3)
            } else {
                performSelector("endGame", withObject: nil, afterDelay: 3)
            }
        }
    }
    
    
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.currentLevel = levelNum
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