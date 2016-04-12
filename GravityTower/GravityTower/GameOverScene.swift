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
        
        let logo = SKSpriteNode(imageNamed: "gravitytower_logo")
        logo.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+200.0))
        self.addChild(logo)
        
        let playBtn = TWButton(size: CGSize(width: 150, height: 75), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        playBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-50.0))
        playBtn.setNormalStateLabelText("Try Again")
        playBtn.setNormalStateLabelFontColor(Constants.Color.White)
        playBtn.setAllStatesLabelFontName(Constants.Font.Main)
        playBtn.setAllStatesLabelFontSize(30.0)
        playBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadGameScene()
        })
        addChild(playBtn)
        
        let mainMenuBtn = TWButton(size: CGSize(width: 150, height: 75), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        mainMenuBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-150.0))
        mainMenuBtn.setNormalStateLabelText("Main Menu")
        mainMenuBtn.setNormalStateLabelFontColor(Constants.Color.White)
        mainMenuBtn.setAllStatesLabelFontName(Constants.Font.Main)
        mainMenuBtn.setAllStatesLabelFontSize(30.0)
        mainMenuBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadMainScene()
        })
        addChild(mainMenuBtn)
        
    }
}