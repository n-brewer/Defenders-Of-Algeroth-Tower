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

class UpgradeScene: UIViewController {
    
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var bouncyImage: UIImageView!
    @IBOutlet weak var totalCoins: UILabel!
    @IBOutlet weak var purchasedLbl: UILabel!
    
    var currentCoins: Int?
    var bouncyBulletPurchased = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bouncyBulletPurchased == true {
            purchasedLbl.text = "Purchased!"
        } else {
            purchasedLbl.text = ""
        }
        
        if currentCoins != nil {
            totalCoins.text = "\(currentCoins!)"
        } else {
            totalCoins.text = "0"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(bouncyImageTapped))
        bouncyImage.addGestureRecognizer(tap)
        
        bouncyImage.layer.cornerRadius = 5.0
        bouncyImage.clipsToBounds = true
        
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
    
    @IBAction func upgradeOptions(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
//            PlayScene.ProjectileSettings.forceMultiplier = 2.0
            //present projectile info
        } else {
            //present castle info
        }
    }
    
    func bouncyImageTapped() {
        let popUp = UIAlertController(title: "Bouncy Bullets", message: "Hit multuple enemies with bouncing bullets!", preferredStyle: .alert)
//        popUp.addAction(UIAlertAction(title: "200 Coins", style: .default, handler: nil))
        popUp.addAction(UIAlertAction(title: "10 Coins", style: .default , handler: { (action) in
            if self.currentCoins != nil && self.currentCoins! >= 1 {
                self.currentCoins! -= 1
                self.bouncyBulletPurchased = true
                self.purchasedLbl.text = "Purchased!"
                self.totalCoins.text = "\(self.currentCoins!)"
                PlayScene.ProjectileSettings.pRadius = 20.0
                PlayScene.ProjectileSettings.forceMultiplier = 2.0

                PlayScene.TowerSettings.towerImage = SKSpriteNode(imageNamed: "Castle.png")
            } else {
                print("Not enough coins")
            }
        }))
        popUp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(popUp, animated: true, completion: nil)
    }
    
    @IBAction func homeBtnTapped(_ sender: UIButton) {
        
//        let scene = GKScene(fileNamed: "GameScene")
//        let sceneNode = scene?.rootNode as! GameScene?
//        let view = self.view as! SKView?
//        view?.presentScene(sceneNode)
//        view?.ignoresSiblingOrder = true
        self.dismiss(animated: true, completion: nil)
    }

}
