//
//  BlitzGameScene.swift
//  GravityTower
//
//  Created by igmstudent on 5/4/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

//
//  GameScene.swift

import SpriteKit

class BlitzGameScene: GameScene {
    
    // MARK: Variables
    let timeLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    var timer = NSTimer()
    var counter = 0
    
    // MARK: Start Game Functions
    override func didMoveToView(view: SKView) {
        // Set up level
        results = LevelResults(level: -2, stars: 0, numBlocks: 0)
        shapes = ["rectangle", "rectangle", "hexagon", "square", "square", "rectangle", "square", "rectangle", "hexagon", "rectangle", "hexagon"]
        
        // Set up Scene
        super.didMoveToView(view)
        levelLabel.text = "Blitz Mode"
        scoreLabel.text = "Blocks: \(results.numBlocks)"
        
        // Timer
        // Start Timer
        timer.invalidate()
        startTimer()
        
        //Time Label
        timeLabel.text = "Time: \(counter)"
        timeLabel.fontSize = 50
        timeLabel.verticalAlignmentMode = .Center
        timeLabel.horizontalAlignmentMode = .Right
        timeLabel.position = CGPoint(x:CGRectGetMaxX(self.frame)-250, y:CGRectGetMaxY(self.frame)-260)
        self.addChild(timeLabel)
    }
    
    // MARK: Timer
    func startTimer(){
        counter = 5
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer.invalidate()
    }
    
    func updateCounter() {
        if playable {
            guard counter > 0 else {
                forceDrop()
                return
            }
            
            counter -= 1
            timeLabel.text = "Time: \(counter)"
        }
    }
    
    //Force drop block
    func forceDrop(){
        pauseTimer()
        
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
        }
        
        startTimer()
    }
    
    // Spawn next block lower than in other screens
    override func spawnNextBlock() {
        nextBlock = FakeBlockNode(imageNamed: shapes[nextIndex]+"-fake")
        
        nextBlock.setup(CGPoint(x:CGRectGetMaxX(self.frame)-290, y:CGRectGetMaxY(self.frame)-320), screen: frame)
        nextBlock.setScale(0.25)
        
        addChild(nextBlock)
    }
    
    // MARK: Collision
    override func didBeginContact(contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if !playable {
            return
        }
        
        if collision == PhysicsCategory.Block | PhysicsCategory.Base || collision == PhysicsCategory.Block | PhysicsCategory.Block{
            //Block landed
            
            pauseTimer()
            
            runAction(SKAction.sequence([
                SKAction.playSoundFileNamed("drop.wav", waitForCompletion: false)
                ]))
            performSelector("checkFinished", withObject: nil, afterDelay: 1)
            startTimer()
            
        } else if collision == PhysicsCategory.Block | PhysicsCategory.Edge {
            pauseTimer()
            blockFell()
        }
    }
    
    //MARK: End Game Functions
    override func save() {
        DefaultsManager.sharedDefaultsManager.setBlitzHighscore(results.numBlocks)
        print("SAVING for BLITZ : this score \(results.numBlocks)")
    }
    
    //MARK: SKS Loading
    class func loadSKSFile() -> BlitzGameScene? {
        let scene = BlitzGameScene(fileNamed: "Empty")!
        print("SETUP Blitz LEVEL")
        scene.scaleMode = .AspectFill
        return scene
    }
}