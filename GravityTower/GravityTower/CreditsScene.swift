//
//  CreditsScene.swift
//  GravityTower
//
//  Created by igmstudent on 4/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class CreditsScene: SKScene {
    
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
    }
    
    class func loadSKSFile() -> CreditsScene? {
        let scene = CreditsScene(fileNamed: "CreditsSceneContents")!
        scene.scaleMode = .AspectFill
        return scene
    }
}