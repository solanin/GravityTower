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
    
    let HIGHEST_LEVEL_UNLOCKED = "unlockedLvl"
    let LVL_1_STARS = "lvl1"
    let LVL_2_STARS = "lvl2"
    let LVL_3_STARS = "lvl3"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // This prevents others from using the default initializer for this class.
    private init() {}
    
    func getLvlUnlcok()->Int{
        if let lvlUnlock:Int? = defaults.integerForKey(HIGHEST_LEVEL_UNLOCKED){
            print("value for lvlUnlock found = \(lvlUnlock)")
            return lvlUnlock!
        }else{
            print("no value for lvlUnlock found")
            return 0
        }
    }
    
    func getStarsForLevel(lvl:Int)->Int{
        var KEY = LVL_1_STARS
        if (lvl == 2) {KEY = LVL_2_STARS}
        if (lvl == 3) {KEY = LVL_3_STARS}

        if let stars:Int? = defaults.integerForKey(KEY){
            print("value for \(KEY) found = \(stars)")
            return stars!
        }else{
            print("no value for \(KEY) found")
            return 0
        }
    }
    
    func setLvlUnlock(lvl:Int){
        defaults.setInteger(lvl, forKey: HIGHEST_LEVEL_UNLOCKED)
        defaults.synchronize()
        print("setting value for lvlUnlock = \(lvl)")
    }
    
    func setStars(stars:Int, lvl:Int){
        var KEY = LVL_1_STARS
        if (lvl == 2) {KEY = LVL_2_STARS}
        if (lvl == 3) {KEY = LVL_3_STARS}
        
        defaults.setInteger(stars, forKey: KEY)
        defaults.synchronize()
        print("setting value for \(KEY)) = \(stars)")
    }
    
}
