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
    
    let button:SKLabelNode = SKLabelNode(fontNamed: Constants.Font.Main)
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.grayColor()
        
        let bg = SKSpriteNode(imageNamed: "background")
        bg.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(bg)
        
        let logo = SKSpriteNode(imageNamed: "gravitytower_logo")
        logo.position = CGPoint(x:CGRectGetMidX(self.frame), y:(CGRectGetMidY(self.frame)+200.0))
        self.addChild(logo)
        
        let control = TWButton(size: CGSize(width: 200, height: 75), normalColor: Constants.Color.Red, highlightedColor: Constants.Color.Blue)
        control.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        control.setNormalStateLabelText("Play")
        control.setNormalStateLabelFontColor(Constants.Color.White)
        control.setAllStatesLabelFontName(Constants.Font.Main)
        control.setAllStatesLabelFontSize(30.0)
        control.addClosure(.TouchUpInside, target: self, closure: { (scene, sender) -> () in
            (self.view!.window!.rootViewController as! GameViewController).loadGameScene()
        })
        addChild(control)
    }
}