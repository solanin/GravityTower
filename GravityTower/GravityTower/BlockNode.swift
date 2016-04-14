//
//  BlockNode.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode, CustomNodeEvents, InteractiveNode {
    
    var dragTouchLocation: CGPoint?         //Location tapped for dragging
    
    func didMoveToScene() {
        userInteractionEnabled = true
    }
    
    func interact() {
        userInteractionEnabled = false
        
        runAction(SKAction.sequence([
            SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
            SKAction.scaleTo(0.8, duration: 0.1),
            //SKAction.removeFromParent()
            ]))
        
        print("interact block node")
    }
    
    
    //Perform upon touch
//    func sceneTouched(touchLocation:CGPoint)
//    {
//        //self.position = touchLocation
//    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("destroy block")
        interact()
    }
    
    //Touch moved event
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        guard let touch = touches.first else {
//            return
//        }
//        let touchLocation = touch.locationInNode(self)
//        sceneTouched(touchLocation)
//    }
}