//
//  BlitzGameOverScene.swift
//  GravityTower
//
//  Created by igmstudent on 5/4/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit

class BlitzGameOverScene: SKScene {
    
    let results: LevelResults
    
    init(size: CGSize, results: LevelResults)
    {
        self.results = results
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(bg)
        
        let gameOverLabel = SKLabelNode(fontNamed: Constants.Font.Main)
        gameOverLabel.text = "Blitz Mode"
        gameOverLabel.fontSize = 250
        gameOverLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+300))
        self.addChild(gameOverLabel)
        
        let blocksLabel = SKLabelNode(fontNamed: Constants.Font.Main)
        blocksLabel.text = "Blocks Stacked: \(self.results.numBlocks)"
        blocksLabel.fontSize = 100
        blocksLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+100))
        self.addChild(blocksLabel)
        
        let playBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        playBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-100))
        playBtn.setNormalStateLabelText("Play Again")
        playBtn.setNormalStateLabelFontColor(Constants.Color.White)
        playBtn.setAllStatesLabelFontName(Constants.Font.Main)
        playBtn.setAllStatesLabelFontSize(40.0)
        playBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadBlitzGameScene()
        })
        addChild(playBtn)
        
        let mainMenuBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Yellow, highlightedColor: Constants.Color.Blue)
        mainMenuBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-300))
        mainMenuBtn.setNormalStateLabelText("Main Menu")
        mainMenuBtn.setNormalStateLabelFontColor(Constants.Color.White)
        mainMenuBtn.setAllStatesLabelFontName(Constants.Font.Main)
        mainMenuBtn.setAllStatesLabelFontSize(40.0)
        mainMenuBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadMainScene()
        })
        addChild(mainMenuBtn)
        
        let highScoreLabel = SKLabelNode(fontNamed: Constants.Font.Main)
        highScoreLabel.text = "High Score: "
        highScoreLabel.fontSize = 80
        highScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)-600))
        self.addChild(highScoreLabel)
        
        let emitterNode = SKEmitterNode(fileNamed: "MyParticle")!
        emitterNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)+400))
        addChild(emitterNode)
        
    }
}