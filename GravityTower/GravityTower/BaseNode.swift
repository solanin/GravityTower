//
//  BaseNode.swift
//  GravityTower
//
//  Created by igmstudent on 4/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit

class BaseNode: SKSpriteNode {
    
    var startPos:CGPoint
    var screen:CGRect
    
    init (imageNamed :String) {
        let texture = SKTexture(imageNamed: imageNamed)
        startPos = CGPoint(x: 0.0, y: 0.0)
        screen = CGRect(x: 1, y: 1, width: 1, height: 1)
        
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(imageNamed: "base")
    }
    
    // MARK: - Methods -
    
    func setup(startPos:CGPoint, screen:CGRect) {
        self.startPos = startPos
        self.screen = screen
        super.position = startPos
        super.physicsBody = SKPhysicsBody(rectangleOfSize: super.size)
        super.physicsBody?.dynamic = false
        super.physicsBody?.categoryBitMask = PhysicsCategory.Base
        super.physicsBody?.contactTestBitMask = PhysicsCategory.None
        super.physicsBody?.collisionBitMask = PhysicsCategory.Block
        super.physicsBody?.collisionBitMask = PhysicsCategory.Edge
        super.physicsBody?.allowsRotation = false
        super.zPosition = SpriteLayer.Sprite
    }
    
    func didMoveToScene() {
        print("base added to scene")
        let baseBodySize = CGSize(width: 300.0, height: 300.0)
        physicsBody = SKPhysicsBody(rectangleOfSize: baseBodySize)
        //physicsBody!.dynamic = false
        
        physicsBody!.categoryBitMask = PhysicsCategory.Base
        physicsBody!.collisionBitMask = PhysicsCategory.Block
        physicsBody!.mass = 100
    }
}
