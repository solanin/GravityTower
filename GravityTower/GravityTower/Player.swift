//
//  Player.swift
//
//
//  Created by igmstudent on 3/17/16.
//  Copyright © 2016 igmstudent. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    
    // MARK: - ivars -
    
    // Screen Calc
    var screen:CGRect
    
    // Player Data
    let MAX_LIVES = 5
    var lives:Int
    
    // Score
    var score:Int
    
    var isDead:Bool {
        return lives <= 0
    }
    
    // MARK: - Initialization -
    
    init () {
        lives = MAX_LIVES
        score = 0
        screen = CGRect(x: 1, y: 1, width: 1, height: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods -
    
    func killPlayer() {
        lives = lives - 1
    }
}