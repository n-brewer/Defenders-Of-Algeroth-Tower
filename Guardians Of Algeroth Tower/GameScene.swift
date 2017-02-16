//
//  GameScene.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/13/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

struct Artifacts {
    static var PlayerCoins: Int = 0
}



class GameScene: SKScene {
    
    var upgradesNode: SKSpriteNode!
    var playNode: SKSpriteNode!
    var coinsEarned: Int?
    var coinsImage: SKSpriteNode!
    var myCoinsLbl: SKLabelNode!
    
    var damageResults: SKLabelNode!
    var towerHpResults: SKLabelNode!
    
    var dragon: Dragon!
    
    override func didMove(to view: SKView) {
        
        damageResults = childNode(withName: "damageResults") as! SKLabelNode
        towerHpResults = childNode(withName: "towerHpResults") as! SKLabelNode
        
        let userStats = UserDefaults.standard
//        if let isBouncy = userStats.value(forKey: Stats.bouncy) {
//            PlayScene.ProjectileSettings.isBouncy = isBouncy as! Bool
//        }
        if let projectileImage = userStats.string(forKey: Stats.projectileImgName) {
            PlayScene.ProjectileSettings.design = SKTexture(imageNamed: projectileImage)
        }
        if let myDamage = userStats.value(forKey: Stats.damage) {
            PlayScene.ProjectileSettings.damage = myDamage as! Int
        } else {
            userStats.set(30, forKey: Stats.damage)
        }
        if let theRadius = userStats.value(forKey: Stats.radius) {
            PlayScene.ProjectileSettings.pRadius = theRadius as! Int
        } else {
            userStats.set(10, forKey: Stats.radius)
        }
        if let myForce = userStats.value(forKey: Stats.force) {
            PlayScene.ProjectileSettings.forceMultiplier = myForce as! CGFloat
        } else {
            userStats.set(0.25, forKey: Stats.force)
        }
        if let towerHp = userStats.value(forKey: Stats.towerHp) {
            PlayScene.TowerSettings.towerHp = towerHp as! Double
        } else {
            userStats.set(100, forKey: Stats.towerHp)
        }
        if let towerImg = userStats.string(forKey: Stats.towerImgName) {
            PlayScene.TowerSettings.towerImage = SKTexture(imageNamed: towerImg)
        }
        if let coinsCollected = userStats.value(forKey: Stats.myCoins) {
            Artifacts.PlayerCoins = coinsCollected as! Int
        } else {
            userStats.set(0, forKey: Stats.myCoins)
        }

        upgradesNode = childNode(withName: "upgrades") as! SKSpriteNode!
        upgradesNode.name = "upgradeMe"
        playNode = childNode(withName: "play") as! SKSpriteNode!
        playNode.name = "play"
        coinsImage = childNode(withName: "coins") as! SKSpriteNode!
        
        myCoinsLbl = SKLabelNode()
        myCoinsLbl.position = CGPoint(x: coinsImage.position.x - 100, y: coinsImage.position.y)
        myCoinsLbl.fontColor = .white
        myCoinsLbl.color = .clear
        myCoinsLbl.horizontalAlignmentMode = .center
        myCoinsLbl.verticalAlignmentMode = .center
        myCoinsLbl.fontName = "Palatino"
        myCoinsLbl.fontSize = 40.0
        self.addChild(myCoinsLbl)
        myCoinsLbl.text = "\(Artifacts.PlayerCoins)"
        self.reloadInputViews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        let location = touch.location(in: self)
        let node = self.atPoint(location)
            
        if node.name == "upgradeMe" {
            upgradesTapped()
        }
        
        if node.name == "play" {
            playTapped()
        }
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        keepDisplaysUpdated()
    }
    
    func upgradesTapped() {
        var actionArray = [SKAction]()
        let action = SKAction.resize(byWidth: 50, height: 40, duration: 0.1)
        let nextAction = SKAction.resize(byWidth: -50, height: -40, duration: 0.1)
        let moveScene = SKAction.run({
            SKAction.wait(forDuration: 0.1)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "UpgradeScene") as! UpgradeScene
            vc.currentCoins = self.coinsEarned
            self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
        })
        
        actionArray.append(action)
        actionArray.append(nextAction)
        actionArray.append(moveScene)
        upgradesNode.run(SKAction.sequence(actionArray))

    }
    
    func playTapped() {

        let fade = SKAction.fadeOut(withDuration: 1.0)
        playNode?.run(fade, completion: {
            let doors = SKTransition.doorway(withDuration: 1.0)
            let playScene = PlayScene(fileNamed: "PlayScene")
            playScene?.scaleMode = .aspectFill
//            playScene?.coins = Artifacts.PlayerCoins
            self.view?.presentScene(playScene!, transition: doors)
        })

    }
    
    func keepDisplaysUpdated() {
        let currentStats = UserDefaults.standard
        let dmg = currentStats.value(forKey: Stats.damage)
        let hp = currentStats.value(forKey: Stats.towerHp)
        let coins = currentStats.value(forKey: Stats.myCoins)
        damageResults.text = "\(dmg!)"
        towerHpResults.text = "\(hp!)"
        myCoinsLbl.text = "\(coins!)"
    }
    
}



















