//
//  PlayScene.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/13/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreData

struct CategoryForNode: OptionSet {
    let rawValue: UInt32
    init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    static let enemy  = CategoryForNode(rawValue: 0b001)
    static let projectile = CategoryForNode(rawValue: 0b010)
    static let tower = CategoryForNode(rawValue: 0b100)
    static let health = CategoryForNode(rawValue: 0b011)
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
    var coinsLbl: SKLabelNode!
    var coins: Int!
    var coinsImage: SKSpriteNode!
    var gameTimer: Timer!
    var enemyAttackTimer: Timer!
    var homeBtn: SKLabelNode!
    var healthBar: HealthBar!
    var enemiesLeft: Int!
    var dragon: Dragon!
    
    var smokeSignal = false
    var waveLbl: SKLabelNode!
    var index: Int!
    var numberOfEnemies: Int!
    var possibleEnemy = [Enemy]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    struct ProjectileSettings {
        static var pRadius = Int(10)
        static let pSnapLimit = CGFloat(10)
        static let pTouchLimit = CGFloat(20)
        static let rangeLimit = CGFloat(80)
        static var forceMultiplier = CGFloat(0.25)
        static var isBouncy: Bool = false
        static var damage: Int = 1
        static var design: SKTexture = SKTexture(imageNamed: "Cannonball")
    }
    
    struct TowerSettings {
        static var towerImage = SKTexture(imageNamed: "Archer Tower.png")
        static var towerHp: Int = 50
    }

    override func didMove(to view: SKView) {
        
        let userStats = UserDefaults.standard
        if let isBouncy = userStats.value(forKey: "bouncy") {
            ProjectileSettings.isBouncy = isBouncy as! Bool
        }
        if let myDamage = userStats.value(forKey: "damage") {
            ProjectileSettings.damage = myDamage as! Int
        }
        if let theRadius = userStats.value(forKey: "radius") {
            ProjectileSettings.pRadius = theRadius as! Int
        }
        if let myForce = userStats.value(forKey: "force") {
            ProjectileSettings.forceMultiplier = myForce as! CGFloat
        }
        if let towerHp = userStats.value(forKey: Stats.towerHp) {
            TowerSettings.towerHp = towerHp as! Int
        }
        //        let specific = NSFetchRequest<NSFetchRequestResult>(entityName: "Upgrades")
//        let all = try! appDelegate.context.execute(specific) as! [Upgrades]
//        for each in all {
//            appDelegate.context.delete(each)
//        }
//        if let myUpgrades = try? appDelegate.context.fetch(Upgrades.fetch) {
//            for each in myUpgrades {
//                appDelegate.context.delete(each)
//                print(each.bouncy ?? "false", each.damage, each.radius)
//                if each.damage > 0 {
//                    ProjectileSettings.damage = each.damage
//                } else {
//                    ProjectileSettings.damage = 1
//                }
//                if each.bouncy != "false" {
//                    ProjectileSettings.isBouncy = each.bouncy!
//                } else {
//                    ProjectileSettings.isBouncy = "false"
//                }
//                if each.radius > 0 {
//                    ProjectileSettings.pRadius = each.radius
//                } else {
//                    ProjectileSettings.pRadius = 10
//                }
//                if each.force > 0 {
//                    ProjectileSettings.forceMultiplier = CGFloat(each.force)
//                } else {
//                    ProjectileSettings.forceMultiplier = 0.25
//                }
//            }
//        }
        
//        if let towerUpgrades = try? appDelegate.context.fetch(TowerUpgrades.fetch) {
//            for each in towerUpgrades {
//                let hp = each.hitPoints
////            let design = each.design
//                TowerSettings.towerHp = hp
//            }
//        }

        if coins == nil {
            coins = 0
        }
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.speed = 0.8
        physicsWorld.contactDelegate = self
        setupScene()
        setupShooter()

        enemiesLeft = 1

        testingWaveAlgorithm()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setupShooter()
        func startDragging(touchLocation: CGPoint, limit: CGFloat) -> Bool {
            let distance = fingerDistanceFromProjectile(projectileRestPosition: projectile.position , fingerPosition: touchLocation)
            
            return distance < CGFloat(ProjectileSettings.pRadius) + limit
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
//            startGameTime()
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
                projectile.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(ProjectileSettings.pRadius))
                projectile.physicsBody?.applyImpulse(CGVector(dx: vectorX * CGFloat(ProjectileSettings.forceMultiplier), dy: vectorY * CGFloat(ProjectileSettings.forceMultiplier)))
                
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
        
        index = 0
        numberOfEnemies = 5
        
        pauseNode = childNode(withName: "pause") as! SKSpriteNode!
        pauseNode.name = "pause"
        resumeNode = childNode(withName: "resume") as! SKSpriteNode!
        resumeNode.name = "resume"
        coinsImage = childNode(withName: "coins") as! SKSpriteNode!
        homeBtn = SKLabelNode()
        homeBtn.text = "Return Home"
        homeBtn.fontName = "Palatino"
        homeBtn.fontSize = 32.0
        homeBtn.fontColor = UIColor.white
        homeBtn.position = CGPoint(x: 0, y: 200)
        homeBtn.name = "home"
        homeBtn.color = UIColor(red: 0.5, green: 0.1, blue: 0.1, alpha: 0.5)
        self.addChild(homeBtn)

        randomTimeInterval = 2.0
        let towerSize: CGSize = CGSize(width: 145, height: 155)
        let towerTexture = TowerSettings.towerImage
        tower = Tower(texture: towerTexture, color: .clear, size: towerSize, hitPoints:(TowerSettings.towerHp))
        tower.name = "tower"
        tower.position = CGPoint(x: (self.view?.frame.size.width)! / 1.5, y: (self.view?.frame.size.height)! / -2)
        tower.physicsBody?.isDynamic = false
        tower.physicsBody = SKPhysicsBody(circleOfRadius: tower.size.width / 2)
        tower.physicsBody?.categoryBitMask = CategoryForNode.tower.rawValue
        tower.physicsBody?.contactTestBitMask = CategoryForNode.enemy.rawValue
        tower.physicsBody?.collisionBitMask = 0
        tower.physicsBody?.affectedByGravity = false
        tower.physicsBody?.restitution = 0.0

        self.addChild(tower)
        
        coinsLbl = SKLabelNode()
        coinsLbl.position = CGPoint(x: coinsImage.position.x - 100, y: coinsImage.position.y)
        coinsLbl.fontColor = .white
        coinsLbl.color = .clear
        coinsLbl.horizontalAlignmentMode = .center
        coinsLbl.verticalAlignmentMode = .center
        coinsLbl.fontName = "Palatino"
        coinsLbl.fontSize = 40.0
        self.addChild(coinsLbl)
        coinsLbl.text = "\(Artifacts.PlayerCoins)"
        
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
        let shotPath = UIBezierPath(arcCenter: CGPoint.zero, radius: CGFloat(ProjectileSettings.pRadius), startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)

        projectile = Projectile(path: shotPath, color: .white, design: ProjectileSettings.design)
        projectile.position = CGPoint(x: tower.position.x - 80, y: tower.position.y + 150)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = CategoryForNode.projectile.rawValue
        projectile.physicsBody?.contactTestBitMask = CategoryForNode.enemy.rawValue
        projectile.physicsBody?.collisionBitMask = 0
        projectile.physicsBody?.restitution = 0.1
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        projectile.physicsBody?.affectedByGravity = false
        
        self.addChild(projectile)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactCategory: CategoryForNode = [contact.bodyA.category, contact.bodyB.category]
        
        if contactCategory.contains([.enemy, .projectile]) {
            if contact.bodyA.category == .enemy {
                projectileHitEnemy(projectileNode: contact.bodyB.node! as! SKShapeNode, enemyNode: contact.bodyA.node! as! Enemy)
            } else if contact.bodyB.category == .enemy {
                projectileHitEnemy(projectileNode: contact.bodyA.node! as! SKShapeNode, enemyNode: contact.bodyB.node! as! Enemy)
            }
        } else if contactCategory.contains([.enemy, .tower]) {
            if contact.bodyA.category == .enemy {
                enemyAttacksTower(towerNode: contact.bodyB.node as! Tower, enemyNode: contact.bodyA.node as! Enemy)
            } else {
                enemyAttacksTower(towerNode: contact.bodyA.node as! Tower, enemyNode: contact.bodyB.node as! Enemy)
            }
        } else {
            print("whatever")
        }
    }
    
    func projectileHitEnemy(projectileNode: SKShapeNode, enemyNode: Enemy) {
        let test = Upgrades(context: appDelegate.context)
        print(test.bouncy, test.damage, test.radius)
        
        if ProjectileSettings.isBouncy == false {
            projectileNode.removeFromParent()
        } else {
            print("Got dem Bouncy's")
        }

        let monster = enemyNode
        monster.hp -= Int(ProjectileSettings.damage)
        monster.healthbar.updateProgress(progress: CGFloat(Float(monster.hp)/2) )
        let blood = createBloodSplatter(dyingEnemy: monster).copy() as! SKEmitterNode
        self.addChild(blood )
        let firstStep = SKAction.wait(forDuration: 1.0)
        let secondStep = SKAction.run {
            blood.removeFromParent()
        }
        blood.run(SKAction.sequence([firstStep, secondStep]))
        
        if monster.hp <= 0 {
            monster.removeAllActions()
            monster.removeFromParent()
            Artifacts.PlayerCoins += monster.coinsGiven
            enemiesLeft! -= 1
            if enemiesLeft != nil && enemiesLeft == 0 {
                self.numberOfEnemies! += 2
                self.index! += 1
                
                self.completedWave()
            }
        } else {
            print("not dead yet")
        }
        
        coinsLbl.text = "\(Artifacts.PlayerCoins)"
    }
    
    func enemyAttacksTower(towerNode: Tower, enemyNode: Enemy) {
        print("ATTACK!")
        let tower = towerNode
        let enemy = enemyNode
        let action = SKAction.run {
            tower.hp -= enemy.damage
            
            if tower.hp <= Int(TowerSettings.towerHp / 2) && self.smokeSignal == false {
                self.smokeSignal = true
                var smoke = SKEmitterNode()
                smoke = SKEmitterNode(fileNamed: "smoke.sks")!
                smoke.position = tower.position
                self.addChild(smoke)
            }
            
            if tower.hp <= 0 {
                let vc = GameOverVC()
                vc.removeFromParentViewController()
                tower.removeFromParent()
                enemy.removeAllActions()
                
                self.gameOverAlert()
            }

            tower.healthbar.updateProgress(progress: CGFloat(Float(tower.hp)/Float(TowerSettings.towerHp)))
            print("HITPOINTS \(tower.hp)")
        }
        
        let delay = SKAction.wait(forDuration: 1.0)
        let seq = SKAction.sequence([action, delay])
        enemy.run(SKAction.repeatForever(seq))
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
    
    func createBloodSplatter(dyingEnemy: SKSpriteNode) -> SKEmitterNode {
        let blood = SKEmitterNode()
        let deadman = dyingEnemy
        
        blood.particleTexture = SKTexture(imageNamed: "particle0.png")
        blood.particleColor = UIColor.red
        blood.numParticlesToEmit = 35
        blood.particleBirthRate = 200
        blood.particleLifetime = 1.0
        blood.emissionAngleRange = 360
        blood.particleSpeed = 50
        blood.particleSpeedRange = 20
        blood.xAcceleration = 0
        blood.yAcceleration = 0
        blood.particleAlpha = 0.8
        blood.particleAlphaRange = 0.2
        blood.particleAlphaSpeed = -0.5
        blood.particleScale = 1.5
        blood.particleScaleRange = 0.4
        blood.particleScaleSpeed = -0.5
        blood.particleRotation = 0
        blood.particleRotationRange = 0
        blood.particleRotationSpeed = 0
        blood.particleColorBlendFactor = 1
        blood.particleColorBlendFactorRange = 0
        blood.particleColorBlendFactorSpeed = 0
        blood.particleBlendMode = SKBlendMode.alpha
        blood.position = deadman.position
        
        return blood
    }

//    func wave1() {
//        
//        var waitLabel: SKLabelNode!
//        var waveArray = [SKAction]()
//        let action = SKAction.run {
//            
//            self.enemiesLeft = 5
//            var enemyArray = [SKSpriteNode]()
//            
//            var enemy2: SKSpriteNode!
//            let endPoint = SKAction.move(to: CGPoint(x: 300, y: 0), duration: 7.0)
//            self.enemy = Dragon()
//            enemy2 = Enemy()
//            
//            enemyArray.append(self.enemy)
//            enemyArray.append(enemy2)
//            self.enemy.run(endPoint)
//            enemy2.run(endPoint)
//            enemyArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemyArray) as! [SKSpriteNode]
//            self.addChild(enemyArray[0])
//            
//        }
//        
//        let lastThing = SKAction.wait(forDuration: 1.5)
//        let all = SKAction.sequence([action, lastThing])
//        waveArray.append(all)
//        
//        let action2 = SKAction.run {
//            
//            self.enemiesLeft = 3
//            var enemyArray = [SKSpriteNode]()
//            
//            var enemy2: SKSpriteNode!
//            let endPoint = SKAction.move(to: CGPoint(x: 300, y: 0), duration: 3.0)
//            self.enemy = Dragon()
//            enemy2 = Enemy()
//            
//            enemyArray.append(self.enemy)
//            enemyArray.append(enemy2)
//            self.enemy.run(endPoint)
//            enemy2.run(endPoint)
//            enemyArray = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemyArray) as! [SKSpriteNode]
//            self.addChild(enemyArray[0])
//            
//        }
//        
//        let pauseAction = SKAction.run { 
//            waitLabel = SKLabelNode()
//            waitLabel.text = "WAVE 1 OVER"
//            waitLabel.position = CGPoint(x: 0, y: 0)
//            self.addChild(waitLabel)
//        }
//        
//        let delayAction = SKAction.wait(forDuration: 5.0)
//        let prepareNextWaveAction = SKAction.run { 
//            waitLabel.removeFromParent()
//        }
//        
//        let waveTransition = SKAction.sequence([pauseAction, delayAction, prepareNextWaveAction])
//        
//        let lastThing2 = SKAction.wait(forDuration: 1.5)
//        let all2 = SKAction.sequence([action2, lastThing2])
//        waveArray.append(all2)
//        
//        let runningWave1 = SKAction.repeat(all, count: 5)
//        let runningWave2 = SKAction.repeat(all2, count: 3)
//        let runWaveDelay = SKAction.repeat(waveTransition, count: 1)
//        self.run(SKAction.sequence([runningWave1, runWaveDelay, runningWave2]))
//    }
    
    func gameOverAlert() {
        let window = UIWindow()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameOver") as! GameOverVC
        vc.removeFromParentViewController()
        vc.view.frame.size = CGSize(width: 200, height: 200)
        vc.view.center = CGPoint(x: window.frame.size.width / 2, y: window.frame.size.height / 2)
        self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func testingWaveAlgorithm() {
        
        enemiesLeft = numberOfEnemies
        
        let spawnAction = SKAction.run {
            var conglomerateOfEnemies = [SKSpriteNode]()
            var dude: SKSpriteNode!
            var redDragon: SKSpriteNode!
            dude = Enemy()
            redDragon = Dragon()
            
            conglomerateOfEnemies.append(dude)
            conglomerateOfEnemies.append(redDragon)
            let indexPicked = arc4random_uniform(UInt32(self.index))
            self.addChild(conglomerateOfEnemies[Int(indexPicked)])
        }
        
        let delayAction = SKAction.wait(forDuration: 2.0)
        
        let actionSeq = SKAction.sequence([spawnAction, delayAction])
        let fullWave = SKAction.repeat(actionSeq, count: numberOfEnemies)
        
        self.run(fullWave)
    }
    
    func completedWave() {
        
        waveLbl = childNode(withName: "waveWon") as! SKLabelNode!
        let displayAction = SKAction.run {
            self.waveLbl.isHidden = false
            self.waveLbl.text = "WAVE \(self.index!) COMPLETE!!"
            self.waveLbl.position = CGPoint(x: 0, y: 0)
        }
        
        let delayWaveAction = SKAction.wait(forDuration: 6.0)
        
        let prepareNextWaveAction = SKAction.run {
            self.waveLbl.isHidden = true
            
        }
        
        let fullTransition = SKAction.sequence([displayAction, delayWaveAction, prepareNextWaveAction])
        let runWaveDelay = SKAction.repeat(fullTransition, count: 1)
        
        self.run(runWaveDelay) { 
            self.testingWaveAlgorithm()
        }
    }
}


extension SKPhysicsBody {
    var category: CategoryForNode {
        get {
            return CategoryForNode(rawValue: self.categoryBitMask)
        }
        set(newValue) {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

extension Upgrades {
    
    class var fetch: NSFetchRequest<Upgrades> {
        return NSFetchRequest<Upgrades>(entityName: "Upgrades")
    }
    
    public override var description: String {
        return "things we have bought in store \(bouncy), \(damage)"
    }
}

extension TowerUpgrades {

    class var fetch: NSFetchRequest<TowerUpgrades> {
        return NSFetchRequest<TowerUpgrades>(entityName: "TowerUpgrades")
    }
}


