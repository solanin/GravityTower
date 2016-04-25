//
//  BlockNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {

    var active: Bool = true

    var isActive: Bool {
        return active
    }
    
    var startPos:CGPoint
    var screen:CGRect
    
    init (imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        startPos = CGPoint(x: 0.0, y: 0.0)
        screen = CGRect(x: 1, y: 1, width: 1, height: 1)
        
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    
    func setup(startPos:CGPoint, rotation:CGFloat, screen:CGRect) {
        self.startPos = startPos
        self.screen = screen
        super.position = startPos
        super.physicsBody = SKPhysicsBody(rectangleOfSize: super.size)
        super.physicsBody?.dynamic = true
        super.physicsBody?.categoryBitMask = PhysicsCategory.Block
        super.physicsBody?.contactTestBitMask = PhysicsCategory.Base | PhysicsCategory.Block | PhysicsCategory.Edge
        super.physicsBody?.collisionBitMask = PhysicsCategory.Base | PhysicsCategory.Block | PhysicsCategory.Edge
        super.zRotation = rotation
        super.zPosition = SpriteLayer.Sprite
    }
    
    func didMoveToScene() {
        userInteractionEnabled = true 
    }
    
    func interact() {
        userInteractionEnabled = false
        self.active = false
        physicsBody!.dynamic = true
        
        print("interact block node")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("touch ended")
        interact()
    }
}