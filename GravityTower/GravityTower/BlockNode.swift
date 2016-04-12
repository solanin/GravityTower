//
//  BlockNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode {
    
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
    
    // MARK: - Methods -
    
    func setup(startPos:CGPoint, screen:CGRect) {
        self.startPos = startPos
        self.screen = screen
        super.position = startPos
        super.physicsBody = SKPhysicsBody(rectangleOfSize: super.size)
        super.physicsBody?.dynamic = true
        super.physicsBody?.categoryBitMask = PhysicsCategory.Block
        super.physicsBody?.contactTestBitMask = PhysicsCategory.None
        super.physicsBody?.collisionBitMask = PhysicsCategory.Base
        super.physicsBody?.collisionBitMask = PhysicsCategory.Block
        super.physicsBody?.collisionBitMask = PhysicsCategory.Edge
        super.physicsBody?.allowsRotation = false
        super.zPosition = SpriteLayer.Sprite
    }
    
    func didMoveToScene() {
        userInteractionEnabled = true
    }
    
    /*
    func interact() {
        userInteractionEnabled = false
        
        runAction(SKAction.sequence([
            SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
            SKAction.scaleTo(0.8, duration: 0.1),
            SKAction.removeFromParent()
            ]))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    print("tapped block")
    }*/
}