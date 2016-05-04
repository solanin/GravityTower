//
//  MainMenuScene.swift
//  GravityTower
//
//  Created by Laura Silva on 4/11/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(bg)
        
        let logo = SKSpriteNode(imageNamed: "gravitytower_logo")
        logo.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+400.0))
        self.addChild(logo)
        
        let playBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        playBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)+100))
        playBtn.setNormalStateLabelText("Play")
        playBtn.setNormalStateLabelFontColor(Constants.Color.White)
        playBtn.setAllStatesLabelFontName(Constants.Font.Main)
        playBtn.setAllStatesLabelFontSize(50.0)
        playBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadLevelSelectScene()
        })
        addChild(playBtn)
        
        let zenBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Green, highlightedColor: Constants.Color.Blue)
        zenBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-50.0))
        zenBtn.setNormalStateLabelText("Zen Mode")
        zenBtn.setNormalStateLabelFontColor(Constants.Color.White)
        zenBtn.setAllStatesLabelFontName(Constants.Font.Main)
        zenBtn.setAllStatesLabelFontSize(40.0)
        zenBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadZenGameScene()
        })
        addChild(zenBtn)
        
        let blitzBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Yellow, highlightedColor: Constants.Color.Blue)
        blitzBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-200.0))
        blitzBtn.setNormalStateLabelText("Blitz Mode")
        blitzBtn.setNormalStateLabelFontColor(Constants.Color.White)
        blitzBtn.setAllStatesLabelFontName(Constants.Font.Main)
        blitzBtn.setAllStatesLabelFontSize(40.0)
        blitzBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadBlitzGameScene()
        })
        addChild(blitzBtn)
        
        let howToBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Orange, highlightedColor: Constants.Color.Blue)
        howToBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-350.0))
        howToBtn.setNormalStateLabelText("How To")
        howToBtn.setNormalStateLabelFontColor(Constants.Color.White)
        howToBtn.setAllStatesLabelFontName(Constants.Font.Main)
        howToBtn.setAllStatesLabelFontSize(40.0)
        howToBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadInstructionsScene()
        })
        addChild(howToBtn)
        
        let creditsBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        creditsBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-500.0))
        creditsBtn.setNormalStateLabelText("Credits")
        creditsBtn.setNormalStateLabelFontColor(Constants.Color.White)
        creditsBtn.setAllStatesLabelFontName(Constants.Font.Main)
        creditsBtn.setAllStatesLabelFontSize(40.0)
        creditsBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadCreditsScene()
        })
        addChild(creditsBtn)
    }
}