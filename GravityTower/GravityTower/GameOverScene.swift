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
    
    override func didMoveToView(view: SKView) {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(bg)
        
        let gameOverLabel = SKLabelNode(fontNamed: Constants.Font.Main)
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 250
        gameOverLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+300.0))
        self.addChild(gameOverLabel)
        
        let playBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        playBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)))
        playBtn.setNormalStateLabelText("Try Again")
        playBtn.setNormalStateLabelFontColor(Constants.Color.White)
        playBtn.setAllStatesLabelFontName(Constants.Font.Main)
        playBtn.setAllStatesLabelFontSize(40.0)
        playBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadLevelSelectScene()
        })
        addChild(playBtn)
        
        let mainMenuBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Yellow, highlightedColor: Constants.Color.Blue)
        mainMenuBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-300.0))
        mainMenuBtn.setNormalStateLabelText("Main Menu")
        mainMenuBtn.setNormalStateLabelFontColor(Constants.Color.White)
        mainMenuBtn.setAllStatesLabelFontName(Constants.Font.Main)
        mainMenuBtn.setAllStatesLabelFontSize(40.0)
        mainMenuBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadMainScene()
        })
        addChild(mainMenuBtn)
        
    }
}