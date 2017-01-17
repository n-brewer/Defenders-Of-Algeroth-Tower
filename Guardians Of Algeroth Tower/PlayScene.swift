//
//  PlayScene.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/13/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import SpriteKit

struct NodeCategory {
    static let enemy: UInt32 = 0x1 << 0
    static let tower: UInt32 = 0x1 << 1
    static let projectile: UInt32 = 0x1 << 2
}


class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var tower: SKSpriteNode!
    var projectile: Projectile!
    var draggingProjectile = false
    var touchStartingPoint: CGPoint!
    var touchCurrentPoint: CGPoint!
    var enemy: SKSpriteNode!
    var randomTimeInterval: TimeInterval = 2.0
    var pauseNode: SKSpriteNode!
    var resumeNode: SKSpriteNode!
    var coinsLbl: UILabel!
    var coins: Int!
    var gameTimer: Timer!
    var homeBtn: SKLabelNode!
//    var skullMan: Enemy!
    
    
    struct ProjectileSettings {
        static var pRadius = CGFloat(10)
        static let pSnapLimit = CGFloat(10)
        static let pTouchLimit = CGFloat(10)
        static let rangeLimit = CGFloat(50)
        static var forceMultiplier = CGFloat(0.5)
//        static var collisionMask: UInt32 = 1
    }

    override func didMove(to view: SKView) {
        
        coins = 0
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.speed = 0.8
        physicsWorld.contactDelegate = self
        setupScene()
        setupShooter()
        startGameTime()
//        wave1()
        
        
        coinsLbl.text = "\(coins!)"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setupShooter()
        func startDragging(touchLocation: CGPoint, limit: CGFloat) -> Bool {
            let distance = fingerDistanceFromProjectile(projectileRestPosition: projectile.position , fingerPosition: touchLocation)
            
            return distance < ProjectileSettings.pRadius + limit
        }
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if !draggingProjectile && startDragging(touchLocation: touchLocation, limit: ProjectileSettings.pTouchLimit) {
                touchStartingPoint = touchLocation
                touchCurrentPoint = touchLocation
                draggingProjectile = true
            }
        }
        let touch: UITouch = touches.first! as UITouch
        let location = touch.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause" {
            self.view?.isPaused = true
            gameTimer.invalidate()
        }
        
        if node.name == "resume" {
            self.view?.isPaused = false
            startGameTime()
        }
        
        if node.name == "home" {
            returnHomeTapped()
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if draggingProjectile {
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let distance = fingerDistanceFromProjectile(projectileRestPosition: touchLocation, fingerPosition: touchStartingPoint)
                if distance < ProjectileSettings.rangeLimit {
                    touchCurrentPoint = touchLocation
                } else {
                    touchCurrentPoint = projectilePositionWhileDragging(fingerPosition: touchLocation, projectileRestPos: touchStartingPoint, rangeLimit: ProjectileSettings.rangeLimit)
                }
            }
            
            projectile.position = touchCurrentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if draggingProjectile {
            draggingProjectile = false
            let distance = fingerDistanceFromProjectile(projectileRestPosition: touchCurrentPoint, fingerPosition: touchStartingPoint)
            if distance > ProjectileSettings.pSnapLimit {
                let vectorX = touchStartingPoint.x - touchCurrentPoint.x
                let vectorY = touchStartingPoint.y - touchCurrentPoint.y
                projectile.physicsBody = SKPhysicsBody(circleOfRadius: ProjectileSettings.pRadius)
                projectile.physicsBody?.applyImpulse(CGVector(dx: vectorX * ProjectileSettings.forceMultiplier, dy: vectorY * ProjectileSettings.forceMultiplier))
                
            } else {
                projectile.physicsBody = nil
                projectile.position = CGPoint(x: tower.position.x, y: tower.position.y + 20)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if projectile.position.x < -655 || projectile.position.y < -355 {
            self.projectile.removeFromParent()
        }
    }
    
    func setupScene() {
        
//        skullMan = Enemy(texture: SKTexture(imageNamed: "skeleton"), color: .clear, size: skullMan.enemySize , hitPoints: 3)
//        skullMan.position = CGPoint(x: 0, y: 0)
//        self.addChild(skullMan)
        
        pauseNode = childNode(withName: "pause") as! SKSpriteNode!
        pauseNode.name = "pause"
        resumeNode = childNode(withName: "resume") as! SKSpriteNode!
        resumeNode.name = "resume"
        homeBtn = SKLabelNode()
        homeBtn.text = "Return Home"
        homeBtn.fontName = "Palatino"
        homeBtn.fontSize = 32.0
        homeBtn.fontColor = UIColor.white
        homeBtn.position = CGPoint(x: 0, y: 200)
        homeBtn.name = "home"
        homeBtn.color = UIColor(red: 0.5, green: 0.1, blue: 0.1, alpha: 0.5)
        self.addChild(homeBtn)
//        homeBtn.size = CGSize(width: 100, height: 40)
        
        
        randomTimeInterval = 2.0
       // let goblin = childNode(withName: "Goblin") as! Enemy
        //goblin.removeFromParent()
        tower = SKSpriteNode(imageNamed: "Archer Tower")
        tower.position = CGPoint(x: (self.view?.frame.size.width)! / 1.5, y: (self.view?.frame.size.height)! / -2)
        tower.setScale(2)
        tower.physicsBody?.affectedByGravity = false
        tower.physicsBody?.isDynamic = true
//        tower.physicsBody = SKPhysicsBody(rectangleOf: tower.size)
        tower.physicsBody?.categoryBitMask = NodeCategory.tower
        tower.physicsBody?.contactTestBitMask = NodeCategory.enemy
        tower.physicsBody?.collisionBitMask = 0
        self.addChild(tower)
        
        coinsLbl = UILabel(frame: CGRect(x: (self.view?.frame.size.width)! - 120, y: 10, width: 100, height: 30))
        coinsLbl.backgroundColor = UIColor(red: 0.7, green: 0.1, blue: 0.1, alpha: 0.7)
        self.view?.addSubview(coinsLbl)
        
        
    }
    
    func fingerDistanceFromProjectile(projectileRestPosition: CGPoint, fingerPosition: CGPoint) -> CGFloat {
        return sqrt(pow(projectileRestPosition.x - fingerPosition.x,2) + pow(projectileRestPosition.y - fingerPosition.y,2))
    }
    
    func projectilePositionWhileDragging(fingerPosition: CGPoint, projectileRestPos: CGPoint, rangeLimit:CGFloat) -> CGPoint {
         let angle = atan2(fingerPosition.x - projectileRestPos.x, fingerPosition.y - projectileRestPos.y)
        let cX = sin(angle) * rangeLimit
        let cY = cos(angle) * rangeLimit
        
        return CGPoint(x: cX + projectileRestPos.x, y: cY + projectileRestPos.y)
    }
    
    func setupShooter() {
//        let shooter = SKSpriteNode(imageNamed: "Castle.png")
//        shooter.position = CGPoint(x: tower.position.x - 5, y: tower.position.y + 1)
//        self.addChild(shooter)
        
        let shotPath = UIBezierPath(arcCenter: CGPoint.zero, radius: ProjectileSettings.pRadius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
//        let design = SKTexture(imageNamed: "Castle.png")

        projectile = Projectile(path: shotPath, color: UIColor.red)
        projectile.position = CGPoint(x: tower.position.x, y: tower.position.y + 150)
        projectile.physicsBody?.isDynamic = true
//        projectile.physicsBody = SKPhysicsBody(circleOfRadius: ProjectileSettings.pRadius)
        projectile.physicsBody?.categoryBitMask = NodeCategory.projectile
        projectile.physicsBody?.contactTestBitMask = NodeCategory.enemy
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.restitution = 0.1
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        projectile.physicsBody?.affectedByGravity = false

        
        self.addChild(projectile)
    }
    
    func spawnEnemy() {
        let minPause: UInt32 = UInt32(1)
        let randomNumber = TimeInterval(arc4random_uniform(5) + minPause)
        randomTimeInterval = randomNumber
        enemy = SKSpriteNode(imageNamed: "GoblinTest.png")
        enemy.size = CGSize(width: 100, height: 100)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.affectedByGravity = false
        
        enemy.physicsBody?.categoryBitMask = NodeCategory.enemy
        enemy.physicsBody?.contactTestBitMask = NodeCategory.projectile | NodeCategory.tower
        enemy.physicsBody?.collisionBitMask = 0
        
        let min = self.size.height / 8
        let max = self.size.height / 2
        let result = (max - min)
        
        let yPosition = Int((arc4random_uniform(UInt32(result) + 100)))
        let properPlace = (yPosition * -1)
        print("\(properPlace)")
        enemy.position = CGPoint(x: -700, y: Int(properPlace))
        enemy.run(SKAction.move(to: CGPoint(x: tower.position.x - 30, y: tower.position.y), duration: 5.0))
        self.addChild(enemy)
        
//        print("\(randomTimeInterval)")
        startGameTime()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask) == (NodeCategory.projectile) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & NodeCategory.projectile) != 0  && (secondBody.categoryBitMask & NodeCategory.enemy) != 0 {
                projectileHitEnemy(projectileNode: firstBody.node as! SKShapeNode, enemyNode: secondBody.node as! SKSpriteNode)
        } else if (firstBody.categoryBitMask & NodeCategory.enemy) != 0 && (secondBody.categoryBitMask & NodeCategory.tower) != 0 {
                enemyAttacksTower(towerNode: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! SKSpriteNode)
        }

    }
    
    
    func projectileHitEnemy(projectileNode: SKShapeNode, enemyNode: SKSpriteNode) {
        print("\(projectileNode)")
        enemyNode.removeFromParent()
        
        coins! += 1
        coinsLbl.text = "\(coins!)"
    }
    
    func enemyAttacksTower(towerNode: SKSpriteNode, enemyNode: SKSpriteNode) {
        print("ATTACK!")
        towerNode.removeFromParent()
    }
    
    
    func startGameTime() {
        gameTimer = Timer.scheduledTimer(timeInterval: randomTimeInterval, target: self, selector: #selector(spawnEnemy), userInfo: nil, repeats: false)

    }
    
    func returnHomeTapped() {
        let goHome = SKAction.wait(forDuration: 0.2)
        homeBtn.run(goHome) {
            let flip = SKTransition.flipHorizontal(withDuration: 1.0)
            let homeScene = GameScene(fileNamed: "GameScene")
            homeScene?.scaleMode = .aspectFill
            homeScene?.coinsEarned = self.coins
            self.view?.presentScene(homeScene!, transition: flip)
            
        }

    }
    
//    func wave1(){
//        let firstAction = SKAction.run { 
//            self.gameTimer
//        }
//        let action = SKAction.repeat(firstAction, count: 3)
//        
//        self.run(action)
//  
//    }

}








