//
//  LevelResults.swift
//  GravityTower
//
//  Created by Laura Silva on 5/4/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

class LevelResults
{
    var level: Int
    var score: Int
    var numBlocks: Int
    
    init(level: Int, score: Int, numBlocks: Int)
    {
        self.level = level
        self.score = score
        self.numBlocks = numBlocks
    }
}