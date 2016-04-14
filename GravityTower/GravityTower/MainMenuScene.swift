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
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(bg)
        
        let logo = SKSpriteNode(imageNamed: "gravitytower_logo")
        logo.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+300.0))
        self.addChild(logo)
        
        let playBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        playBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)))
        playBtn.setNormalStateLabelText("Play")
        playBtn.setNormalStateLabelFontColor(Constants.Color.White)
        playBtn.setAllStatesLabelFontName(Constants.Font.Main)
        playBtn.setAllStatesLabelFontSize(50.0)
        playBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadGameScene()
        })
        addChild(playBtn)
        
        let howToBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Yellow, highlightedColor: Constants.Color.Blue)
        howToBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-150.0))
        howToBtn.setNormalStateLabelText("How To")
        howToBtn.setNormalStateLabelFontColor(Constants.Color.White)
        howToBtn.setAllStatesLabelFontName(Constants.Font.Main)
        howToBtn.setAllStatesLabelFontSize(40.0)
        howToBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadInstructionsScene()
        })
        addChild(howToBtn)
        
        let creditsBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Green, highlightedColor: Constants.Color.Blue)
        creditsBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (CGRectGetMidY(self.frame)-300.0))
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