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

class BlitzGameScene: SKScene, SKPhysicsContactDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Variables

    let results: LevelResults = LevelResults(level: -2, stars: 0, numBlocks: 0)
    var timer = NSTimer()
    var counter = 60
    
    // UI
    let timeLabel = SKLabelNode(fontNamed: Constants.Font.Main)
    
    // Levels
    let shapes: [String] = ["rectangle", "rectangle", "hexagon", "square", "square", "rectangle", "square", "rectangle", "hexagon", "rectangle", "hexagon"]

    // Shapes Array index
    var currentIndex = 0;
    var nextIndex = -1;
    
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
            nextBlock.removeFromParent()
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
            
            if (nextIndex == -1) {
                currentIndex = Int(arc4random_uniform(UInt32(shapes.count))); // randomBetweenNumbers
                nextIndex = Int(arc4random_uniform(UInt32(shapes.count))); // randomBetweenNumbers
            } else {
                currentIndex = nextIndex
                nextIndex = Int(arc4random_uniform(UInt32(shapes.count))); // randomBetweenNumbers
            }
            
            tempBlock = FakeBlockNode(imageNamed: shapes[currentIndex]+"-fake")

            
            //tempBlock.zRotation = CGFloat(Int(arc4random()) % 80)
            tempBlock.setup(CGPoint(x: CGRectGetMidX(self.frame)-randomBetweenNumbers(-200, secondNum: 200), y: (self.frame.height - 250.0)), screen: frame)
            addChild(tempBlock)
            spawnNextBlock()
        }
    }
    
    // Spawns the temporary "next" icon block
    func spawnNextBlock() {
        nextBlock = FakeBlockNode(imageNamed: shapes[nextIndex]+"-fake")
        
        nextBlock.setup(CGPoint(x: CGRectGetMaxX(self.frame)-100, y:CGRectGetMaxY(self.frame)-100), screen: frame)
        nextBlock.setScale(0.25)
        
        addChild(nextBlock)
    }
    
    // MARK: Timer
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounter"), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer.invalidate()
    }
    
    func updateCounter() {
        if playable {
            guard counter > 0 else {
                lose()
                return
            }
            
            counter -= 1
            
            timeLabel.text = "Time: \(counter)"
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
            pauseTimer()
            scoreLabel.text = "Blocks: \(results.numBlocks)"
            lose()
        }
    }
    
    
    // MARK: End game functions

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
    
    //MARK: Lose conditions
    func lose() {
        playable = false
        
        DefaultsManager.sharedDefaultsManager.setBlitzHighscore(results.numBlocks)
        print("SAVING for BLITZ : this score \(results.numBlocks)")
        
        runAction(SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false))
        results.numBlocks = allBlocks.count - 1
        inGameMessage("Total: \(results.numBlocks)")
        
        performSelector("endGame", withObject: nil, afterDelay: 5)
    }
    
    //MARK: SKS Loading
    class func loadSKSFile() -> BlitzGameScene? {
        let scene = BlitzGameScene(fileNamed: "Empty")!
        print("SETUP Blitz LEVEL")
        scene.scaleMode = .AspectFill
        return scene
    }
}