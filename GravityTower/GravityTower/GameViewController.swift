//
//  GameViewController.swift
//  CatNap
//
//  Created by Marin Todorov on 10/17/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    // MARK: - ivars -
    var gameScene: GameScene?
    var skView:SKView!
    let showDebugData = true
    let screenSize = CGSize(width: 1080, height: 1920)
    let scaleMode = SKSceneScaleMode.AspectFill
    
    // MARK: - Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = MainMenuScene(size:CGSize(width: 2048, height: 1536))

        //if let scene = GameScene.level(1) {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
          
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = scaleMode
            
            skView.presentScene(scene)
        //}
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func loadGameScene(){
        gameScene = GameScene.level(1)
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = false
        
        skView.presentScene(gameScene)
        
    }
    
    func loadInstructionsScene(){
        let scene = HowToScene(size:CGSize(width: 2048, height: 1536))
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = scaleMode
        
        skView.presentScene(scene)
        
    }
    
    func loadMainScene(){
        let scene = MainMenuScene(size:CGSize(width: 2048, height: 1536))
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = scaleMode
        
        skView.presentScene(scene)
        
    }
    
    func loadCreditsScene(){
        let scene = CreditsScene(size:CGSize(width: 2048, height: 1536))
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = false
        scene.scaleMode = scaleMode
        
        skView.presentScene(scene)
        
    }
}
