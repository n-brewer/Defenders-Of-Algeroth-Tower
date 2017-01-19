//
//  UpgradeScene.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/15/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class UpgradeScene: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var shopView: UIView!
//    @IBOutlet weak var bouncyImage: UIImageView!
    @IBOutlet weak var totalCoins: UILabel!
    @IBOutlet weak var purchasedLbl: UILabel!
    @IBOutlet weak var gameView: SKView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentCoins: Int?
    var bouncyBulletPurchased = false
    
    var projectileArray = ["Bouncy Bullets", "Mega Cannon", "Spiked Cannon"]
    var projUpgImgs = ["BouncyBullet", "Cannonball", "spiked"]
    var towerArray = ["Stone Keep", "Mighty Fortress"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalCoins.text = "\(Artifacts.PlayerCoins)"
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        if bouncyBulletPurchased == true {
//            purchasedLbl.text = "Purchased!"
//        } else {
//            purchasedLbl.text = ""
//        }
//        
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(bouncyImageTapped))
//        bouncyImage.addGestureRecognizer(tap)
//        
//        bouncyImage.layer.cornerRadius = 5.0
//        bouncyImage.clipsToBounds = true
        
        shopView.layer.borderColor = UIColor(red: 30/255, green: 106/255, blue: 139/255, alpha: 1).cgColor
        shopView.layer.borderWidth = 1.0
        shopView.layer.cornerRadius = 5.0
        
        let font = UIFont(name: "Palatino", size: 17.0)
//
        let textStyle = NSDictionary(object: font!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(textStyle as? [AnyHashable : Any], for: UIControlState.normal)
//        sectionControl.setTitleTextAttributes(textStyle, for: .normal)
        
//        let theView = view as! SKView
//        let gamerScene = GameScene(size: view.bounds.size)
//        gamerScene.scaleMode = SKSceneScaleMode.resizeFill
//        
//        theView.presentScene(gamerScene)

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeCell") as! UpgradeCell
        
        let titles = projectileArray[indexPath.row]
        let upgradeImages = projUpgImgs[indexPath.row]
        let status = "Purchased!"
        
        cell.configureCell(image: upgradeImages, title: titles, status: status)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        upgradeSelected(index: indexPath.row)
    }
    
    @IBAction func upgradeOptions(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
//            PlayScene.ProjectileSettings.forceMultiplier = 2.0
            //present projectile info
        } else {
            //present castle info
        }
    }
    
//    func bouncyImageTapped() {
//        let popUp = UIAlertController(title: "Bouncy Bullets", message: "Hit multuple enemies with bouncing bullets!", preferredStyle: .alert)
////        popUp.addAction(UIAlertAction(title: "200 Coins", style: .default, handler: nil))
//        popUp.addAction(UIAlertAction(title: "10 Coins", style: .default , handler: { (action) in
//            if self.currentCoins != nil && self.currentCoins! >= 1 {
//                self.currentCoins! -= 1
//                self.bouncyBulletPurchased = true
//                self.purchasedLbl.text = "Purchased!"
//                self.totalCoins.text = "\(self.currentCoins!)"
//                PlayScene.ProjectileSettings.pRadius = 20.0
//                PlayScene.ProjectileSettings.forceMultiplier = 2.0
//
////                PlayScene.TowerSettings.towerImage = SKSpriteNode(imageNamed: "Castle.png")
//            } else {
//                print("Not enough coins")
//            }
//        }))
//        popUp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(popUp, animated: true, completion: nil)
//    }
    
    @IBAction func homeBtnTapped(_ sender: UIButton) {
        let scene = GKScene(fileNamed: "GameScene")
        let sceneNode = scene?.rootNode as! GameScene?
        sceneNode?.scaleMode = .aspectFill
        sceneNode?.coinsEarned = currentCoins
//        gameView.isHidden = false
//        gameView.presentScene(sceneNode)
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentAlertView(title: String, message: String, coins: Int, index: Int) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Buy for \(coins)!", style: .default, handler: { (action) in
            if Artifacts.PlayerCoins >= coins {
                Artifacts.PlayerCoins -= coins
                self.totalCoins.text = "\(Artifacts.PlayerCoins)"
                switch index {
                case 0:
                    PlayScene.ProjectileSettings.isBouncy = true
                case 1:
                    PlayScene.ProjectileSettings.pRadius = 15
                    PlayScene.ProjectileSettings.forceMultiplier = 1.5
                    PlayScene.ProjectileSettings.damage = 2
                default:
                    print("bought nothin'")
                }
            } else {
                print("Get more money!")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func upgradeSelected(index: Int) {
        
        switch index {
        case 0:
            print("first Cell")
            presentAlertView(title: "Bouncy Bullets", message: "Hit multiple enemies with these bouncing bullets!", coins: 2, index: index)
        case 1:
            presentAlertView(title: "Big Balls of Steel", message: "Bigger cannonball, more damage. Enjoy!", coins: 10, index: index)
        default:
            print("missed something")
        }
    }

}










