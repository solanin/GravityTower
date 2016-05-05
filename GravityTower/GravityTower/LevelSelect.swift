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
        levelLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+500.0))
        self.addChild(levelLabel)
        
        let lvl1Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        lvl1Btn.position = CGPoint(x: CGRectGetMidX(self.frame)-300, y: CGRectGetMidY(self.frame)+200)
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
        label1.position = CGPoint(x: CGRectGetMidX(self.frame)-300, y: CGRectGetMidY(self.frame)+40)
        addChild(label1)
        
        if (DefaultsManager.sharedDefaultsManager.getLvlUnlcok() > 1) {
    
            let lvl2Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
            lvl2Btn.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+200)
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
            label2.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)+40)
            addChild(label2)
        
        }
        if (DefaultsManager.sharedDefaultsManager.getLvlUnlcok() > 2) {
            
            let lvl3Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
            lvl3Btn.position = CGPoint(x: CGRectGetMidX(self.frame)+300, y: CGRectGetMidY(self.frame)+200)
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
            label3.position = CGPoint(x: CGRectGetMidX(self.frame)+300, y: CGRectGetMidY(self.frame)+40)
            addChild(label3)
        }
        
        if (DefaultsManager.sharedDefaultsManager.getLvlUnlcok() > 3) {
            
            let lvl4Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
            lvl4Btn.position = CGPoint(x: CGRectGetMidX(self.frame)-300, y: CGRectGetMidY(self.frame)-200)
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
            label4.position = CGPoint(x: CGRectGetMidX(self.frame)-300, y: CGRectGetMidY(self.frame)-360)
            addChild(label4)
        }
        
        if (DefaultsManager.sharedDefaultsManager.getLvlUnlcok() > 4) {
            let lvl5Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
            lvl5Btn.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)-200)
            lvl5Btn.setNormalStateLabelText("5")
            lvl5Btn.setNormalStateLabelFontColor(Constants.Color.White)
            lvl5Btn.setAllStatesLabelFontName(Constants.Font.Main)
            lvl5Btn.setAllStatesLabelFontSize(60.0)
            lvl5Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
                (self.view!.window!.rootViewController as! GameViewController).loadGameScene(5)
            })
            addChild(lvl5Btn)
            
            let label5 = SKLabelNode(fontNamed: Constants.Font.Main)
            label5.text = formatStars(DefaultsManager.sharedDefaultsManager.getStarsForLevel(5))
            label5.fontSize = 60
            label5.fontColor = Constants.Color.White
            label5.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame)-360)
            addChild(label5)
        }
        
        if (DefaultsManager.sharedDefaultsManager.getLvlUnlcok() > 5) {
            
            let lvl6Btn = TWButton(size: CGSize(width: 200, height: 200), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
            lvl6Btn.position = CGPoint(x: CGRectGetMidX(self.frame)+300, y: CGRectGetMidY(self.frame)-200)
            lvl6Btn.setNormalStateLabelText("6")
            lvl6Btn.setNormalStateLabelFontColor(Constants.Color.White)
            lvl6Btn.setAllStatesLabelFontName(Constants.Font.Main)
            lvl6Btn.setAllStatesLabelFontSize(60.0)
            lvl6Btn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
                (self.view!.window!.rootViewController as! GameViewController).loadGameScene(6)
            })
            addChild(lvl6Btn)
            
            let label6 = SKLabelNode(fontNamed: Constants.Font.Main)
            label6.text = formatStars(DefaultsManager.sharedDefaultsManager.getStarsForLevel(6))
            label6.fontSize = 60
            label6.fontColor = Constants.Color.White
            label6.position = CGPoint(x: CGRectGetMidX(self.frame)+300, y: CGRectGetMidY(self.frame)-360)
            addChild(label6)
        }
        
        
        let zenBtn = TWButton(size: CGSize(width: 350, height: 200), normalColor: Constants.Color.Orange, highlightedColor: Constants.Color.Blue)
        zenBtn.position = CGPoint(x: CGRectGetMidX(self.frame)-225, y: (CGRectGetMidY(self.frame)-600))
        zenBtn.setNormalStateLabelText("Zen Mode")
        zenBtn.setNormalStateLabelFontColor(Constants.Color.White)
        zenBtn.setAllStatesLabelFontName(Constants.Font.Main)
        zenBtn.setAllStatesLabelFontSize(50.0)
        zenBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadZenGameScene()
        })
        addChild(zenBtn)
        
        let blitzBtn = TWButton(size: CGSize(width: 350, height: 200), normalColor: Constants.Color.Yellow, highlightedColor: Constants.Color.Blue)
        blitzBtn.position = CGPoint(x: CGRectGetMidX(self.frame)+225, y: (CGRectGetMidY(self.frame)-600))
        blitzBtn.setNormalStateLabelText("Blitz Mode")
        blitzBtn.setNormalStateLabelFontColor(Constants.Color.White)
        blitzBtn.setAllStatesLabelFontName(Constants.Font.Main)
        blitzBtn.setAllStatesLabelFontSize(50.0)
        blitzBtn.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadBlitzGameScene()
        })
        addChild(blitzBtn)
    }
    
    class func loadSKSFile() -> LevelSelect? {
        let scene = LevelSelect(fileNamed: "LevelSelectContents")!
        scene.scaleMode = .AspectFill
        return scene
    }
}