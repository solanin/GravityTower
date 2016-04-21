//
//  FakeBlockNode.swift
//
//
//  
//

import SpriteKit

class FakeBlockNode: SKSpriteNode, CustomNodeEvents {
    
    var startPos:CGPoint
    var screen:CGRect
    var hasBeenSet = false
    
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
        super.zPosition = SpriteLayer.Sprite
        super.physicsBody = SKPhysicsBody(rectangleOfSize: super.size)
        super.physicsBody?.dynamic = true
        super.physicsBody?.mass = 20
        super.physicsBody?.categoryBitMask = PhysicsCategory.Block
        super.physicsBody?.contactTestBitMask = PhysicsCategory.Base | PhysicsCategory.Block | PhysicsCategory.Edge
        super.physicsBody?.collisionBitMask = PhysicsCategory.Base | PhysicsCategory.Block | PhysicsCategory.Edge
        
        hasBeenSet = true
    }
    
    func didMoveToScene() {
        userInteractionEnabled = true
    }
}