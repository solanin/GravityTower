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
    let HIGHEST_SCORE_ZEN = "zenScore"
    let HIGHEST_SCORE_BLITZ = "blitzScore"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // This prevents others from using the default initializer for this class.
    private init() {}
    
    func getLvlUnlcok()->Int{
        if let lvlUnlock:Int? = defaults.integerForKey(HIGHEST_LEVEL_UNLOCKED){
            //print("value for lvlUnlock found = \(lvlUnlock)")
            return lvlUnlock!
        }else{
            //print("no value for lvlUnlock found")
            return 0
        }
    }
    
    func getStarsForLevel(lvl:Int)->Int{
        var KEY = LVL_1_STARS
        if (lvl == 2) {KEY = LVL_2_STARS}
        if (lvl == 3) {KEY = LVL_3_STARS}

        if let stars:Int? = defaults.integerForKey(KEY){
            //print("value for \(KEY) found = \(stars)")
            return stars!
        }else{
            //print("no value for \(KEY) found")
            return 0
        }
    }
    
    func getZenHighscore()->Int{
        if let zenScore:Int? = defaults.integerForKey(HIGHEST_SCORE_ZEN){
            //print("value for HIGHEST_SCORE_ZEN found = \(zenScore)")
            return zenScore!
        }else{
            //print("no value for HIGHEST_SCORE_ZEN found")
            return 0
        }
    }
    
    func getBlitzHighscore()->Int{
        if let blitzScore:Int? = defaults.integerForKey(HIGHEST_SCORE_BLITZ){
            //print("value for HIGHEST_SCORE_BLITZ found = \(blitzScore)")
            return blitzScore!
        }else{
            //print("no value for HIGHEST_SCORE_BLITZ found")
            return 0
        }
    }
    
    func setLvlUnlock(lvl:Int){
        if (getLvlUnlcok() < lvl) {
            defaults.setInteger(lvl, forKey: HIGHEST_LEVEL_UNLOCKED)
            defaults.synchronize()
            //print("setting value for lvlUnlock = \(lvl)")
        }
    }
    
    func setStars(stars:Int, lvl:Int){
        if (getStarsForLevel(lvl) < stars) {
            var KEY = LVL_1_STARS
            if (lvl == 2) {KEY = LVL_2_STARS}
            if (lvl == 3) {KEY = LVL_3_STARS}
        
            defaults.setInteger(stars, forKey: KEY)
            defaults.synchronize()
            //print("setting value for \(KEY)) = \(stars)")
        }
    }
    
    func setZenHighscore(score:Int){
        if (getZenHighscore() < score) {
            defaults.setInteger(score, forKey: HIGHEST_SCORE_ZEN)
            defaults.synchronize()
            //print("setting value for HIGHEST_SCORE_ZEN = \(score)")
        }
    }
    
    func setBlitzHighscore(score:Int){
        if (getBlitzHighscore() < score) {
            defaults.setInteger(score, forKey: HIGHEST_SCORE_BLITZ)
            defaults.synchronize()
            //print("setting value for HIGHEST_SCORE_BLITZ = \(score)")
        }
    }
    
}
