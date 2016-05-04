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
        backBtn.position = CGPoint(x:CGRectGetMinX(self.frame) + 320, y: CGRectGetMaxY(self.frame)-100)
        backBtn.setNormalStateLabelText("Back")
        backBtn.setNormalStateLabelFontColor(Constants.Color.White)
        backBtn.setAllStatesLabelFontName(Constants.Font.Main)
        backBtn.setAllStatesLabelFontSize(40.0)
        backBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadMainScene()
        })
        addChild(backBtn)
        
        let levelLabel = SKLabelNode(fontNamed: Constants.Font.Main)
        levelLabel.text = "Select a Level"
        levelLabel.fontSize = 150
        levelLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+300.0))
        self.addChild(levelLabel)
        
        let lvl1Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        lvl1Btn.position = CGPoint(x: CGRectGetMidX(self.frame)-150, y: CGRectGetMidY(self.frame))
        lvl1Btn.setNormalStateLabelText("1")
        lvl1Btn.setNormalStateLabelFontColor(Constants.Color.White)
        lvl1Btn.setAllStatesLabelFontName(Constants.Font.Main)
        lvl1Btn.setAllStatesLabelFontSize(60.0)
        lvl1Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadGameScene(1)
        })
        addChild(lvl1Btn)
        
        let label1 = SKLabelNode(fontNamed: Constants.Font.Main)
        label1.text = formatStars(DefaultsManager.sharedDefaultsManager.getStarsForLevel(1))
        label1.fontSize = 60
        label1.fontColor = Constants.Color.White
        label1.position = CGPoint(x: CGRectGetMidX(self.frame)-150, y: CGRectGetMidY(self.frame)-160)
        addChild(label1)
        
        if (DefaultsManager.sharedDefaultsManager.getLvlUnlcok() > 1) {
    
            let lvl2Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Orange, highlightedColor: Constants.Color.Blue)
            lvl2Btn.position = CGPoint(x: CGRectGetMidX(self.frame)+150, y: CGRectGetMidY(self.frame))
            lvl2Btn.setNormalStateLabelText("2")
            lvl2Btn.setNormalStateLabelFontColor(Constants.Color.White)
            lvl2Btn.setAllStatesLabelFontName(Constants.Font.Main)
            lvl2Btn.setAllStatesLabelFontSize(60.0)
            lvl2Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
                (self.view!.window!.rootViewController as! GameViewController).loadGameScene(2)
            })
            addChild(lvl2Btn)
            
            let label2 = SKLabelNode(fontNamed: Constants.Font.Main)
            label2.text = formatStars(DefaultsManager.sharedDefaultsManager.getStarsForLevel(2))
            label2.fontSize = 60
            label2.fontColor = Constants.Color.White
            label2.position = CGPoint(x: CGRectGetMidX(self.frame)+150, y: CGRectGetMidY(self.frame)-160)
            addChild(label2)
        
        }
        if (DefaultsManager.sharedDefaultsManager.getLvlUnlcok() > 2) {
            
            let lvl3Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Yellow, highlightedColor: Constants.Color.Blue)
            lvl3Btn.position = CGPoint(x: CGRectGetMidX(self.frame)-150, y: CGRectGetMidY(self.frame) - 400)
            lvl3Btn.setNormalStateLabelText("3")
            lvl3Btn.setNormalStateLabelFontColor(Constants.Color.White)
            lvl3Btn.setAllStatesLabelFontName(Constants.Font.Main)
            lvl3Btn.setAllStatesLabelFontSize(60.0)
            lvl3Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
                (self.view!.window!.rootViewController as! GameViewController).loadGameScene(3)
            })
            addChild(lvl3Btn)
            
            let label3 = SKLabelNode(fontNamed: Constants.Font.Main)
            label3.text = formatStars(DefaultsManager.sharedDefaultsManager.getStarsForLevel(3))
            label3.fontSize = 60
            label3.fontColor = Constants.Color.White
            label3.position = CGPoint(x: CGRectGetMidX(self.frame)-150, y: CGRectGetMidY(self.frame)-560)
            addChild(label3)
        }
        
        if (DefaultsManager.sharedDefaultsManager.getLvlUnlcok() > 3) {
            
            let lvl4Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Green, highlightedColor: Constants.Color.Blue)
            lvl4Btn.position = CGPoint(x: CGRectGetMidX(self.frame)+150, y: CGRectGetMidY(self.frame) - 400)
            lvl4Btn.setNormalStateLabelText("4")
            lvl4Btn.setNormalStateLabelFontColor(Constants.Color.White)
            lvl4Btn.setAllStatesLabelFontName(Constants.Font.Main)
            lvl4Btn.setAllStatesLabelFontSize(60.0)
            lvl4Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
                (self.view!.window!.rootViewController as! GameViewController).loadGameScene(4)
            })
            addChild(lvl4Btn)
            
            let label4 = SKLabelNode(fontNamed: Constants.Font.Main)
            label4.text = formatStars(DefaultsManager.sharedDefaultsManager.getStarsForLevel(4))
            label4.fontSize = 60
            label4.fontColor = Constants.Color.White
            label4.position = CGPoint(x: CGRectGetMidX(self.frame)+150, y: CGRectGetMidY(self.frame)-560)
            addChild(label4)
        }
        
        
    }
    
    class func loadSKSFile() -> LevelSelect? {
        let scene = LevelSelect(fileNamed: "LevelSelectContents")!
        scene.scaleMode = .AspectFill
        return scene
    }
    
    func formatStars(stars:Int) -> String {
        if stars < 1 {return "···"}
        else if stars == 1 {return "★··"}
        else if stars == 2 {return "★★·"}
        else {return "★★★"}
        
    }
}