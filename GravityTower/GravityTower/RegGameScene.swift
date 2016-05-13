//
//  GameScene.swift
//

import SpriteKit

class RegGameScene : GameScene {
    
    // MARK: Variables
    let tipLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    var goal: GoalNode!
    
    //Levels
    let LAST_LEVEL = 7
    let starCuttoff: [Int] = [4, 3, 6, 5, 9, 10]
    let level1: [String] = ["square", "rectangle", "hexagon", "triangle"]
    let level2: [String] = ["rectangle", "square", "square", "rectangle", "square", "rectangle", "rectangle", "square", "square", "square"]
    let level3: [String] = ["square", "rectangle", "triangle", "triangle", "rectangle", "rectangle", "square", "square", "rectangle", "triangle", "rectangle", "square", "square", "square"]
    let level4: [String] = ["rectangle", "hexagon", "hexagon", "rectangle", "square", "rectangle", "square", "hexagon", "rectangle", "square", "square", "rectangle", "hexagon", "triangle"]
    let level5: [String] = ["rectangle", "triangle", "triangle", "rectangle", "hexagon", "square", "rectangle", "square", "square", "rectangle", "hexagon"]
    let level6: [String] = ["square", "square", "hexagon", "rectangle", "rectangle", "hexagon", "rectangle", "square", "rectangle", "rectangle", "hexagon", "square", "rectangle", "triangle"]
    
    // MARK: Start Game Functions
    override func didMoveToView(view: SKView) {
        // Set up level
        results = LevelResults(level: results.level, stars: 3, numBlocks: 0)
        switch (results.level) {
        case 1:
            shapes = level1
        case 2:
            shapes = level2
        case 3:
            shapes = level3
        case 4:
            shapes = level4
        case 5:
            shapes = level5
        case 6:
            shapes = level6
        default:
            shapes = level1
        }
        
        //Tip label
        if (results.level == 1) {
            tipLabel.text = "Tap to drop block"
            tipLabel.fontSize = 80
            tipLabel.verticalAlignmentMode = .Center
            tipLabel.horizontalAlignmentMode = .Center
            tipLabel.position = CGPoint(x: 0, y: 450)
            theCamera.addChild(tipLabel)
        }
        
        // set up goal line
        goal = childNodeWithName("//Goal") as! GoalNode
        
        // Set up Scene
        super.didMoveToView(view)
    }
    
    // MARK: Spawn Functions
    
    // Called in Spawns the Real Block
    override func calcShowScore () {
        // Clac Stars
        if (allBlocks.count > starCuttoff[results.level-1]) {
            results.stars = 2
            if (allBlocks.count > starCuttoff[results.level-1] + 2) {
                results.stars = 1
            }
            scoreLabel.text = formatStars(results.stars)
        }
        print("\(results.level) : \(allBlocks.count) / \(starCuttoff[results.level-1]) = \(results.stars)")
        
        currentIndex += 1
        
        if (results.level == 1 && currentIndex == 1) {
            tipLabel.text = "Drag to slide block"
        } else if (results.level == 1 && currentIndex == 2) {
            tipLabel.text = "Use two fingers to rotate"
        }
        else if (results.level == 1 && currentIndex == 3) {
            tipLabel.text = "Pass the goal line to beat the level"
        }
        
        if (currentIndex >= shapes.count) {
            currentIndex = 0
        }
    }
    
    // Set up temporary block in stage mode
    override func spawnBlock() {
        if !playable{
            return
        }
        
        if !tempHasSpawned { // Spawn temporary block
            tempHasSpawned = true
            
            tempBlock = FakeBlockNode(imageNamed: shapes[currentIndex]+"-fake")
            
            // Camera
            START_POINT = theCamera.position.y + 300.0
            if (allBlocks.count > 0 ) { hero.position = (allBlocks.last?.position)! }
            
            // Set Up Onboarding
            if (results.level == 1) {
                switch (currentIndex) {
                case 0:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame), y: START_POINT), screen: frame)
                case 1:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-300, y: START_POINT), screen: frame)
                case 2:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame), y: START_POINT), screen: frame)
                    tempBlock.zRotation = CGFloat(M_PI_2)
                case 3:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)+200, y: START_POINT), screen: frame)
                    tempBlock.zRotation = CGFloat(M_PI)
                default:
                    tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-randomBetweenNumbers(-200, secondNum: 200), y: START_POINT), screen: frame)
                }
            } else {
                tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-randomBetweenNumbers(-200, secondNum: 200), y: START_POINT), screen: frame)
            }
            
            addChild(tempBlock)
            spawnNextBlock()
        }
    }
    
    // Spawns the temporary "next" icon block
    override func spawnNextBlock() {
        
        if (currentIndex < shapes.count - 1) {
            nextIndex = currentIndex+1
        } else {
            nextIndex = 0
        }
        
        super.spawnNextBlock()
    }
    
    // MARK: Collision
    override func blockFell() {
        runAction(SKAction.sequence([
            SKAction.playSoundFileNamed("fall.wav", waitForCompletion: false)
            ]))
        lose()
    }
    
    // MARK: End Game functions
    func newGame() {
        view?.presentScene(RegGameScene.level(results.level))
        print("LOADING Level \(results.level)")
        self.levelLabel.text = "Level \(results.level)"
        msgHasSpawned = false
    }
    
    override func checkFinished() {
        if (currentBlock.physicsBody?.velocity.dy < 1 &&
            currentBlock.physicsBody?.velocity.dy > -1 ) {
            if currentBlock.position.y + currentBlock.size.height >= goal.position.y {
                win()
            } else {
                spawnBlock()
            }
        }
    }
    
    override func lose() {
        playable = false
        currentIndex = 0
        
        DefaultsManager.sharedDefaultsManager.setLvlUnlock(results.level)
        print("SAVING for LEVEL \(results.level) : unlocked lvl \(results.level)")
        
        SKTAudio.sharedInstance().playSoundEffect("lose.wav")
        
        inGameMessage("Try again...")
        performSelector("newGame", withObject: nil, afterDelay: 5)
    }
    
    func win() {
        if !msgHasSpawned {
            msgHasSpawned = true
            
            playable = false
            currentIndex = 0
            
            DefaultsManager.sharedDefaultsManager.setLvlUnlock(results.level+1)
            DefaultsManager.sharedDefaultsManager.setStars(results.stars, lvl: results.level)
            print("SAVING for LEVEL \(results.level) : unlocked lvl \(results.level+1) and earned \(results.stars) stars")
            
            runAction(SKAction.playSoundFileNamed("win.wav", waitForCompletion: false))
            
            let msg = formatStars(results.stars)
            inGameMessage(msg)
            
            //INCREASE LEVEL
            results.level += 1
            
            if (results.level < LAST_LEVEL) {
                performSelector("newGame", withObject: nil, afterDelay: 3)
            } else {
                performSelector("endGame", withObject: nil, afterDelay: 3)
            }
        }
    }
    
    //MARK: SKS Loading
    class func level(levelNum: Int) -> RegGameScene? {
        let scene = RegGameScene(fileNamed: "Level\(levelNum)")!
        scene.results.level = levelNum
        print("SETUP Level \(levelNum)")
        scene.scaleMode = .AspectFill
        return scene
    }
}