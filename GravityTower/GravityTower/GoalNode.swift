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
    
    var startPos:CGPoint
    var screen:CGRect
    
    init (imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        
        startPos = CGPoint(x: 0.0, y: 0.0)
        screen = CGRect(x: 1, y: 1, width: 1, height: 1)
        
        super.init(texture: texture, color: UIColor.blackColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    func setup(startPos:CGPoint, screen:CGRect) {
        self.startPos = startPos
        self.screen = screen
        super.position = startPos
        super.physicsBody = SKPhysicsBody(rectangleOfSize: super.size)
        super.physicsBody?.dynamic = false
        super.physicsBody?.categoryBitMask = PhysicsCategory.Goal
        super.physicsBody?.contactTestBitMask = PhysicsCategory.Block
        super.physicsBody?.collisionBitMask = PhysicsCategory.Edge
        super.zPosition = SpriteLayer.Sprite
    }
}