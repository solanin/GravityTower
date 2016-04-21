//
//  GoalNode.swift
//  GravityTower
//
//  Created by Laura Silva on 4/20/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit

class GoalNode: SKSpriteNode {
    var met: Bool = false
    
    // check if the goal has been met/reached
    var isMet: Bool {
        return false
    }
    
    func didMoveToScene() {
        print("Goal added to scene")
    }
}