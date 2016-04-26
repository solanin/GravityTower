//
//  LevelSelect.swift
//  GravityTower
//
//  Created by igmstudent on 4/25/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSelect: SKScene {
    
    override func didMoveToView(view: SKView) {
        let backBtn = TWButton(size: CGSize(width: 250, height: 100), normalColor: Constants.Color.Green, highlightedColor: Constants.Color.Blue)
        backBtn.position = CGPoint(x: 200.0, y:self.frame.height - 150.0)
        backBtn.setNormalStateLabelText("Back")
        backBtn.setNormalStateLabelFontColor(Constants.Color.White)
        backBtn.setAllStatesLabelFontName(Constants.Font.Main)
        backBtn.setAllStatesLabelFontSize(40.0)
        backBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadMainScene()
        })
        addChild(backBtn)
        
        let lvl1Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        lvl1Btn.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+300)
        lvl1Btn.setNormalStateLabelText("1")
        lvl1Btn.setNormalStateLabelFontColor(Constants.Color.White)
        lvl1Btn.setAllStatesLabelFontName(Constants.Font.Main)
        lvl1Btn.setAllStatesLabelFontSize(60.0)
        lvl1Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadGameSceneOne()
        })
        addChild(lvl1Btn)
        
        let lvl2Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Orange, highlightedColor: Constants.Color.Blue)
        lvl2Btn.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        lvl2Btn.setNormalStateLabelText("2")
        lvl2Btn.setNormalStateLabelFontColor(Constants.Color.White)
        lvl2Btn.setAllStatesLabelFontName(Constants.Font.Main)
        lvl2Btn.setAllStatesLabelFontSize(60.0)
        lvl2Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadGameSceneTwo()
        })
        addChild(lvl2Btn)
        
        let lvl3Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Yellow, highlightedColor: Constants.Color.Blue)
        lvl3Btn.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)-300)
        lvl3Btn.setNormalStateLabelText("3")
        lvl3Btn.setNormalStateLabelFontColor(Constants.Color.White)
        lvl3Btn.setAllStatesLabelFontName(Constants.Font.Main)
        lvl3Btn.setAllStatesLabelFontSize(60.0)
        lvl3Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadGameSceneThree()
        })
        addChild(lvl3Btn)
        
        
    }
    
    class func loadSKSFile() -> LevelSelect? {
        let scene = LevelSelect(fileNamed: "LevelSelectContents")!
        scene.scaleMode = .AspectFill
        return scene
    }
}