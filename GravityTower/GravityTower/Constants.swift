//
//  Constants.swift
//  GravityTower
//
//  Created by igmstudent on 4/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit

// This file contains constant variables that can be accessed thoughout the game files

struct Constants{
    struct Font {
        static let Title = "Bebas"
        static let Main = "Bebas"
        static let text = "Noteworthy-Bold"
    }
    
    struct HUD{
        static let FontSize = CGFloat(50.0)
        static let Margin = CGFloat(10.0)
    }
    
    struct Label{
        static let title = "Gravity Tower"
    }
    
    struct Color {
        static let Blue = SKColor(red: (20/255), green: (40/255), blue: (78/255), alpha: 1.0)
        static let Red = SKColor(red: (190/255), green: (32/255), blue: (38/255), alpha: 1.0)
        static let Green = SKColor(red: (8/255), green: (133/255), blue: (29/255), alpha: 1.0)
        static let Orange = SKColor(red: (255/255), green: (106/255), blue: (6/255), alpha: 1.0)
        static let Yellow = SKColor(red: (240/255), green: (218/255), blue: (54/255), alpha: 1.0)
        static let White = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
}