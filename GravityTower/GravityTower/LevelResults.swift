//
//  LevelResults.swift
//  GravityTower
//
//  Created by Laura Silva on 5/4/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

class LevelResults {
    var level: Int //-1 = Zen -2 = Blitz
    var stars: Int
    var numBlocks: Int
    
    init(level: Int, stars: Int, numBlocks: Int) {
        self.level = level
        self.stars = stars
        self.numBlocks = numBlocks
    }
}