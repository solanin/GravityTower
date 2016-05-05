//
//  GameOverScene.swift
//  GravityTower
//
//  Created by Laura Silva on 4/11/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
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
        
        if results.level < 0 {
            let hsLabel = SKLabelNode(fontNamed: Constants.Font.Main)
            if results.level == -1 {
                if (DefaultsManager.sharedDefaultsManager.getZenHighscore() == results.numBlocks) {
                    hsLabel.text = "High Score!"
                }
                else {
                    hsLabel.text = "High Score : \(DefaultsManager.sharedDefaultsManager.getZenHighscore())"
                }
            } else if results.level == -2 {
                if (DefaultsManager.sharedDefaultsManager.getBlitzHighscore() == results.numBlocks) {
                    hsLabel.text = "High Score!"
                }
                else {
                    hsLabel.text = "High Score : \(DefaultsManager.sharedDefaultsManager.getBlitzHighscore())"
                }
            }
            hsLabel.fontSize = 100
            hsLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+50.0))
            self.addChild(hsLabel)
        }
    
        let gameOverLabel = SKLabelNode(fontNamed: Constants.Font.Main)
        if results.level < 0 {
            gameOverLabel.text = "Score: \(results.numBlocks)"
        } else {
            gameOverLabel.text = "You Win!"
        }
        gameOverLabel.fontSize = 250
        gameOverLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+300.0))
        self.addChild(gameOverLabel)
        
        
        let playBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        playBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-100))
        playBtn.setNormalStateLabelText("Play Again")
        playBtn.setNormalStateLabelFontColor(Constants.Color.White)
        playBtn.setAllStatesLabelFontName(Constants.Font.Main)
        playBtn.setAllStatesLabelFontSize(40.0)
        
        if results.level == -1 {
            playBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
                (self.view!.window!.rootViewController as! GameViewController).loadZenGameScene()
            })
        } else if results.level == -2 {
            playBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
                (self.view!.window!.rootViewController as! GameViewController).loadBlitzGameScene()
            })
        }
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
        
        let emitterNode = SKEmitterNode(fileNamed: "MyParticle")!
        emitterNode.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)+400))
        addChild(emitterNode)
    }

}