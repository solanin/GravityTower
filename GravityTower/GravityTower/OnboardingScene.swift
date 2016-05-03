//
//  Onboarding.swift
//  GravityTower
//
//  Created by Laura Silva on 5/3/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

class OnboardingScene: SKScene {
    
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
        
        
        let centerPoint =
            CGPoint(x: CGRectGetMidX(self.frame), y: (self.frame.height - 250.0))
        
        runAction(SKAction.group([
            SKAction.moveTo(centerPoint, duration: 0.66),
            SKAction.rotateToAngle(20, duration: 0.5)
            ]))

    }
    
    
    class func loadSKSFile() -> OnboardingScene? {
        let scene = OnboardingScene(fileNamed: "HowToInteractive")!
        scene.scaleMode = .AspectFill
        return scene
    }
}