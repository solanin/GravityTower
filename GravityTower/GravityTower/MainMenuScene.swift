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
        backgroundColor = UIColor.grayColor()
        
        let logo = SKSpriteNode(imageNamed: "gravitytower_logo")
        logo.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(logo)
    }
}