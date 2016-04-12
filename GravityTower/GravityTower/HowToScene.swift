//
//  HowToScene.swift
//  GravityTower
//
//  Created by igmstudent on 4/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class HowToScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(bg)
        
        
        
        let playBtn = TWButton(size: CGSize(width: 150, height: 75), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        playBtn.position = CGPoint(x: CGRectGetMidX(self.frame), y: (200.0))
        playBtn.setNormalStateLabelText("Play")
        playBtn.setNormalStateLabelFontColor(Constants.Color.White)
        playBtn.setAllStatesLabelFontName(Constants.Font.Main)
        playBtn.setAllStatesLabelFontSize(30.0)
        playBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadGameScene()
        })
        addChild(playBtn)
        
        let backBtn = TWButton(size: CGSize(width: 150, height: 75), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        backBtn.position = CGPoint(x: 600.0, y:self.frame.height - 150.0)
        backBtn.setNormalStateLabelText("Back")
        backBtn.setNormalStateLabelFontColor(Constants.Color.White)
        backBtn.setAllStatesLabelFontName(Constants.Font.Main)
        backBtn.setAllStatesLabelFontSize(30.0)
        backBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadMainScene()
        })
        addChild(backBtn)
    }
}