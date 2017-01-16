//
//  UpgradeScene.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/15/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import SpriteKit

class UpgradeScene: UIViewController {
    
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var bouncyImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        popUp.addAction(UIAlertAction(title: "200 Coins", style: .default, handler: nil))
        popUp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(popUp, animated: true, completion: nil)
//        popUp.addAction(UIAlertController(title: "Bouncy Bullets", message: "Hit multiple enemies with these bouncing bullets!", preferredStyle: .alert))
    }

}
