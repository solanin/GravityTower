//
//  DefaultsManager.swift
//  PhonePortraitGame
//
//  Created by jefferson on 3/14/16.
//  Copyright © 2016 tony. All rights reserved.
//

import Foundation

class DefaultsManager{
   static let sharedDefaultsManager = DefaultsManager() // single instance
    
    let HIGH_SCORE_KEY = "highScoreKey"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // This prevents others from using the default initializer for this class.
    private init() {}
    
    func getHighScore()->Int{
        if let highScore:Int? = defaults.integerForKey(HIGH_SCORE_KEY){
            print("value for highScoreKey found = \(highScore)")
            return highScore!
        }else{
            print("no value for highScoreKey found")
            return 0
        }
    }
    
    func setHighScore(score:Int){
        defaults.setInteger(score, forKey: HIGH_SCORE_KEY)
        defaults.synchronize()
        print("setting value for highScoreKey = \(score)")
    }
    
    
}
