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

class ZenGameScene: GameScene {
        
    // MARK: Start Game Functions
    override func didMoveToView(view: SKView) {
        // Set up level
        results = LevelResults(level: -1, stars: 0, numBlocks: 0)
        shapes = ["rectangle"]//, "hexagon", "square"]
        
        // Set up Scene
        super.didMoveToView(view)
        levelLabel.text = "Zen Mode"
        scoreLabel.text = "Blocks: \(results.numBlocks)"
    }
    
    // MARK: End Game Functions  
    override func save() {
        DefaultsManager.sharedDefaultsManager.setZenHighscore(results.numBlocks)
        print("SAVING for ZEN : this score \(results.numBlocks)")
    }
    
    //MARK: SKS Loading
    class func loadSKSFile() -> ZenGameScene? {
        let scene = ZenGameScene(fileNamed: "Empty")!
        print("SETUP Zen LEVEL")
        scene.scaleMode = .AspectFill
        return scene
    }
}