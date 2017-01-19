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
    
    var enemyColor = UIColor.red
    var design = SKTexture()
    var enemySize = CGSize()
    var hp: Int
    
    init(texture: SKTexture?, color: UIColor, size: CGSize?, hitPoints: Int) {
        
        self.hp = hitPoints

        super.init(texture: texture, color: color, size: size!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class Tower: SKSpriteNode {
    
    var hp: Int
    init(texture: SKTexture?, color: UIColor, size: CGSize, hitPoints: Int) {
        self.hp = hitPoints
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}







