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
    convenience init(path: UIBezierPath, color: UIColor, design: SKTexture) {
        self.init()
        self.fillTexture = design
        self.path = path.cgPath
        self.fillColor = color
    }
}


class Enemy: SKSpriteNode {
    
    var textureAtlas: SKTextureAtlas!
    var textureArray = [SKTexture]()
    var enemyColor = UIColor.clear
    var design = SKTexture(imageNamed: "GoblinTest.png")
    var enemySize = CGSize(width: 80, height: 80)
    var hp: Double = 2
    var damage: Double = 1
    var healthbar: HealthBar!
    var coinsGiven: Int = 1
    
    init(texture: SKTexture?, color: UIColor, size: CGSize?, hitPoints: Double, coinsEarned: Int, dmg: Double) {
        self.design = texture!
        self.enemySize = size!
        self.enemyColor = color
        self.hp = hitPoints
        self.damage = dmg
        self.coinsGiven = coinsEarned
        
        textureAtlas = SKTextureAtlas(named: "walk.atlas")
        
        for i in 0..<textureAtlas.textureNames.count {
            let name = "walk\(i)"
            textureArray.append(SKTexture(imageNamed: name))
        }

        super.init(texture: texture, color: color, size: size!)
        
        createDaBody()
        physicsBody?.restitution = 0.5
        self.healthbar = HealthBar()
        self.healthbar.updateProgress(progress: 1.0)
        
        self.addChild(healthbar)
        
        

    }
    
//    func prepareForNextWave() {
//        hp += 3
//        speed *= 1.1
//        damage *= 1.2
//        
//    }
    
    convenience init(hitPoints: Double, dmg: Double, speed: CGFloat) {

        self.init(texture: SKTexture(imageNamed: "walk1.png"), color: .clear, size: CGSize(width: 80, height: 80), hitPoints: hitPoints, coinsEarned: 100, dmg: dmg)
        self.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.1)))
        
//        let min = self.size.height / 8
//        let max = self.size.height / 2
//        let result = (max - min)
//        let yPosition = Int((arc4random_uniform(UInt32(result) + 100)))
//        let properPlace = (yPosition * 1)
        let window = UIWindow()
        self.position = CGPoint(x: -700, y: window.frame.size.height / -2)
        self.run(SKAction.move(to: CGPoint(x: (window.frame.size.width / 1.5) - 150, y: window.frame.size.height / -2), duration: 7.0))
        
//        prepareForNextWave()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDaBody() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = CategoryForNode.enemy.rawValue
        self.physicsBody?.contactTestBitMask = CategoryForNode.tower.rawValue
        self.physicsBody?.collisionBitMask = CategoryForNode.tower.rawValue | CategoryForNode.enemy.rawValue
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.allowsRotation = false

    }
    
}

class Dragon: Enemy {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize?, hitPoints: Double, coinsEarned: Int, dmg damage: Double) {
        
        super.init(texture: texture, color: color, size: size, hitPoints: hitPoints, coinsEarned: coinsEarned, dmg: damage)
        
    }
    
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "flyingDragon.png"), color: .clear, size: CGSize(width: 150, height: 150), hitPoints: 6, coinsEarned: 3, dmg: 3)
        
        let min = self.size.height / 8
        let max = self.size.height / 2
        let result = (max - min)
        let yPosition = Int((arc4random_uniform(UInt32(result) + 100)))
        let properPlace = (yPosition * 1)
        let window = UIWindow()
        self.position = CGPoint(x: -700, y: properPlace)
        self.run(SKAction.move(to: CGPoint(x: (window.frame.size.width / 1.5) - 150, y: (window.frame.size.height / -2) + 100), duration: 10.0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Ogre: Enemy {
    
    var ogreAtlas: SKTextureAtlas!
    var ogreArray = [SKTexture]()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize?, hitPoints: Double, coinsEarned: Int, dmg damage: Double) {
        
        ogreAtlas = SKTextureAtlas(named: "OgreWalk.atlas")
        
        for i in 1...ogreAtlas.textureNames.count {
            let name = "Ogre\(i)"
            ogreArray.append(SKTexture(imageNamed: name))
        }

        
        super.init(texture: texture, color: color, size: size, hitPoints: hitPoints, coinsEarned: coinsEarned, dmg: damage)
        
    }
    
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "Ogre1.png"), color: .clear, size: CGSize(width: 180, height: 200), hitPoints: 15, coinsEarned: 6, dmg: 10)
        self.run(SKAction.repeatForever(SKAction.animate(with: ogreArray, timePerFrame: 0.1)))
        let window = UIWindow()
        self.position = CGPoint(x: -700, y: window.frame.size.height / -2.5)
        self.run(SKAction.move(to: CGPoint(x: (window.frame.size.width / 1.5) - 130, y: window.frame.size.height / -2), duration: 10.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class Tower: SKSpriteNode {
    
    var hp: Double
    var healthbar: HealthBar!
    init(texture: SKTexture?, color: UIColor, size: CGSize, hitPoints: Double) {
        self.hp = hitPoints
        super.init(texture: texture, color: color, size: size)
        
        self.name = "tower"
        self.healthbar = HealthBar()
        self.healthbar.updateProgress(progress: 1.0)
        self.healthbar.position = CGPoint(x: self.position.x - 30, y: self.position.y + (self.size.height / 2) + 15)
        self.healthbar.size = CGSize(width: 200, height: 40)
        self.healthbar.xScale = 1.0
        self.healthbar.yScale = 1.0
        xScale = 1.5
        yScale = 1.5
        self.addChild(healthbar)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HealthBar: SKSpriteNode {
    
    var healthColor: SKSpriteNode!
    var barBorder: SKSpriteNode!
    var enemy: Enemy!
    
    required init() {
        super.init(texture: nil, color: .clear, size: CGSize(width: 100, height: 20))
        
        self.healthColor = SKSpriteNode(texture: SKTexture(imageNamed: "barbackground.png"), color: UIColor.green, size: CGSize(width: 100, height: 20))
        
        self.addChild(self.healthColor)
        
        self.healthColor.colorBlendFactor = 1.0
        
        self.barBorder = SKSpriteNode(texture: SKTexture(imageNamed: "healtbar.png"), color: UIColor.white, size: CGSize(width:102, height: 22))
        
        self.addChild(self.barBorder)
        
        self.healthColor.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.barBorder.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        
        xScale = 0.5
        yScale = 0.5
        position = CGPoint(x: self.position.x - 20, y: self.position.y - 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgress(progress: CGFloat) {
        
        var localProgress = progress
        if localProgress <= 0.0 {
            
            localProgress = 0.0
        }
        
        let barSize = localProgress * 100.0
        let lifeColor = localProgress * 60.0
        
        let red : CGFloat = (32.0 + 2.0 * (60.0 - lifeColor)) / 255.0
        let green : CGFloat = (32.0 + 2.0 * lifeColor) / 255.0
        let blue : CGFloat = 32.0 / 255.0
        
        self.healthColor.color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.healthColor.size = CGSize(width: barSize, height: self.healthColor.size.height)
    }
    
}







