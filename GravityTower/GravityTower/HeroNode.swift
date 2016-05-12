//
//  HeroNode.swift
//  GravityTower
//
//  Created by Laura Silva on 5/6/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//


import SpriteKit

class HeroNode: SKSpriteNode {
    
    var startPos:CGPoint
    var screen:CGRect
    
    convenience init () {
        let texture = SKTexture(imageNamed: "vol")
        self.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    convenience init (imageNamed :String) {
        let texture = SKTexture(imageNamed: imageNamed)
        self.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
    }
    
    override init(texture: SKTexture!, color: (SKColor!), size: CGSize) {
        startPos = CGPoint(x: 0.0, y: 0.0)
        screen = CGRect(x: 1, y: 1, width: 1, height: 1)
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setup(startPos:CGPoint) {
        super.position = startPos
        super.zPosition = SpriteLayer.Sprite
    }
    
    
}