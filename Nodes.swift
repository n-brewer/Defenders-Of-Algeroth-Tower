//
//  Units.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/13/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import SpriteKit

class Projectile: SKShapeNode {
    convenience init(path: UIBezierPath, color: UIColor) {
        self.init()
        
        self.path = path.cgPath
        self.fillColor = color
    }
}


class Enemy: SKSpriteNode {
    var integrity: Int = 2 {
        didSet {
            if integrity > 2 {
                integrity = 2
            }
            
            if integrity < 0 {
                removeFromParent()
            }
            //insert texture of enemy
        }
    }
    
}
