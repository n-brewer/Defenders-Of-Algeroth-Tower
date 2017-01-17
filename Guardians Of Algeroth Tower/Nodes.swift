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


//class Enemy: SKSpriteNode {
//    
//    var enemyColor = UIColor.red
//    var design = SKTexture()
//    var enemySize = CGSize()
//    var hp: Int
//    
//    init(texture: SKTexture, color: UIColor, size: CGSize, hitPoints: Int) {
////        super.init(texture: <#T##SKTexture?#>, color: <#T##UIColor#>, size: <#T##CGSize#>)
//        
//        self.hp = hitPoints
//
//        super.init(texture: texture, color: color, size: size)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
////        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//class SkullMan: Enemy {
//    
//    var newHp: Int = 5
//    init() {
//        super.init(texture: SkullMan.init().design, color: SkullMan.init().enemyColor, size: SkullMan.init().enemySize, hitPoints: newHp)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}








