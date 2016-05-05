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
        counter = 5
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
    
    // MARK: Collision
    override func blockFell() {
        pauseTimer()
        super.blockFell()
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