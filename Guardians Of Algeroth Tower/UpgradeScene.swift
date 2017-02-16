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
import CoreData

class UpgradeScene: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var statDamage = "damage"
    var statForce = "force"
    var force: Double = 0.25
    
    var purchased = [false, false, false, false]
    
    @IBOutlet weak var shopView: UIView!
//    @IBOutlet weak var bouncyImage: UIImageView!
    @IBOutlet weak var totalCoins: UILabel!
    @IBOutlet weak var purchasedLbl: UILabel!
    @IBOutlet weak var gameView: SKView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var myTableView: UITableView!
    
    var currentCoins: Int?
    var bouncyBulletPurchased = false
//    var titles: [String]?
//    var images: [String]?
    var status = "Buy Me!"
    var dmgLevel: Int?
    var moreDmgCost: Int!
    
    var projectileIsSelected = true
    var towerIsSelected = false
    
    var projectileArray = ["Bouncy Bullets", "Mega Cannon", "Spiked Cannon", "Damage++"]
    var projUpgImgs = ["BouncyBullet", "Cannonball", "spiked", "Damage++"]
    var proStatusArray = ["Buy Me", "Purchased!"]
    
    var towerArray = ["Stone Keep", "Fortress of Algeroth"]
    var towerImages = ["keep", "MyFortress"]
    var levelArray = [String]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalCoins.text = "\(Artifacts.PlayerCoins)"
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        shopView.layer.borderColor = UIColor(red: 30/255, green: 106/255, blue: 139/255, alpha: 1).cgColor
        shopView.layer.borderWidth = 1.0
        shopView.layer.cornerRadius = 5.0
        
        let font = UIFont(name: "Palatino", size: 17.0)
        let textStyle = NSDictionary(object: font!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(textStyle as? [AnyHashable : Any], for: UIControlState.normal)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if towerIsSelected == true {
            return towerArray.count
        } else if projectileIsSelected == true {
            return projectileArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpgradeCell") as? UpgradeCell
//        let cellRow = tableView.cellForRow(at: indexPath) as? UpgradeCell
        let someStats = UserDefaults.standard
        if let damageLevel = someStats.value(forKey: Stats.damageLvl) {
            self.dmgLevel = damageLevel as? Int
        } else {
            self.dmgLevel = 1
        }

        levelArray = ["", "", "", "Level \(dmgLevel!)"]
        moreDmgCost = (dmgLevel! * 5)
            if projectileIsSelected == true {
                let title = projectileArray[indexPath.row]
                let image = projUpgImgs[indexPath.row]
                let level = levelArray[indexPath.row]
                
                cell?.purchaseStatus.text = level
                
                
                cell?.configureCell(image: image, title: title)

                return cell!
            } else if towerIsSelected == true {
                let title = towerArray[indexPath.row]
                let image = towerImages[indexPath.row]
//                let status = self.status
            
                cell?.configureCell(image: image, title: title)

                return cell!
            } else {
                print("make selection")
        }
        
            return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UpgradeCell
        upgradeSelected(index: indexPath.row, cell: cell)
    }
    
    @IBAction func upgradeOptions(_ sender: UISegmentedControl) {
        
        
    }
    @IBAction func segmentThis(_ sender: UISegmentedControl) {
        print("HERE \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            
            projectileIsSelected = true
            towerIsSelected = false
            myTableView.reloadData()

        } else  {
            
            projectileIsSelected = false
            towerIsSelected = true
            myTableView.reloadData()
        }
    }
    
    @IBAction func homeBtnTapped(_ sender: UIButton) {
//        let scene = GKScene(fileNamed: "GameScene")
//        let sceneNode = scene?.rootNode as! GameScene?
//        sceneNode?.reloadInputViews()
//        sceneNode?.scaleMode = .aspectFill
//        sceneNode?.coinsEarned = currentCoins
//        gameView.isHidden = false
//        gameView.presentScene(sceneNode)
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentAlertView(title: String, message: String, coins: Int, index: Int, cell: UpgradeCell) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "\(coins) coins!", style: .default, handler: { (action) in
            if Artifacts.PlayerCoins >= coins {
                let upgradeValues = UserDefaults.standard
                Artifacts.PlayerCoins -= coins
                self.totalCoins.text = "\(Artifacts.PlayerCoins)"
                
                if self.projectileIsSelected == true {
//                    let upgradeValues = UserDefaults.standard
                    switch index {
                    case 0:
                        upgradeValues.set(true, forKey: Stats.bouncy)
                        self.purchased[index] = true
//                        upgradeValues.set("Purchased!", forKey: Stats.status)
//                        cell.purchaseStatus.text = upgradeValues.string(forKey: Stats.status)
                    case 1:
                        upgradeValues.set(2, forKey: Stats.damage)
                        upgradeValues.set(20, forKey: Stats.radius)
                        upgradeValues.set(1.5, forKey: Stats.force)
                        self.purchased[index] = true
//                        upgradeValues.set("Purchased!", forKey: Stats.status)
//                        cell.purchaseStatus.text = upgradeValues.string(forKey: Stats.status)
                    case 2:
                        upgradeValues.set(3, forKey: Stats.damage)
                        upgradeValues.set(30, forKey: Stats.radius)
                        upgradeValues.set(2, forKey: Stats.force)
                        upgradeValues.set("spiked", forKey: Stats.projectileImgName)
                        self.purchased[index] = true
//                        upgradeValues.set("Purchased!", forKey: Stats.status)
//                        cell.purchaseStatus.text = upgradeValues.string(forKey: Stats.status)
                    case 3:
                        var currentLvl = upgradeValues.integer(forKey: Stats.damageLvl)
                        if currentLvl >= 10 {
                            currentLvl = 10
                        } else {
                            let currentLvl = upgradeValues.integer(forKey: Stats.damageLvl)
                            let newLvl = currentLvl + 1
                            upgradeValues.set(newLvl, forKey: Stats.damageLvl)
                            let currentDmg = upgradeValues.integer(forKey: Stats.damage)
                            let newDmg = currentDmg + 1
                            upgradeValues.set(newDmg, forKey: Stats.damage)
//                            cell.purchaseStatus.text = "Level \(self.dmgLevel)"
                        }
                        
                    default:
                        print("bought nothin'")
                    }
                    
                } else if self.towerIsSelected == true {
//                    let upgradeValues = UserDefaults.standard
                    switch index {
                    case 0:
                        PlayScene.TowerSettings.towerImage = SKTexture(imageNamed: "Castle.png")
                        upgradeValues.set(200, forKey: Stats.towerHp)
                        self.purchased[index] = true
                    case 1:
                        upgradeValues.set("MyFortress", forKey: Stats.towerImgName)
                        upgradeValues.set(500, forKey: Stats.towerHp)
                        self.purchased[index] = true
                    default:
                        print("bought nothin'")
                    }
                }
                upgradeValues.set(Artifacts.PlayerCoins, forKey: Stats.myCoins)
                self.myTableView.reloadData()
            } else {
                print("Get more money!")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func upgradeSelected(index: Int, cell: UpgradeCell) {
        if projectileIsSelected {
            switch index {
            case 0:
                print("first Cell")
                presentAlertView(title: "Bouncy Bullets", message: "Hit multiple enemies with these bouncing bullets!", coins: 2, index: index, cell: cell)
            case 1:
                presentAlertView(title: "Big Balls of Steel", message: "Bigger cannonball, more damage. Enjoy!", coins: 1, index: index, cell: cell)
            case 2:
                presentAlertView(title: "Big Balls of Steel, with Spikes", message: "Add spikes 'cuz why not!", coins: 1, index: index, cell: cell)
            case 3:
                if self.dmgLevel! >= 10 {
                    presentAlertView(title: "Maxed Out!", message: "Your damage has been maxed out", coins: 0, index: index, cell: cell)
                } else {
                    presentAlertView(title: "More Damage Please", message: "Like I said, more damage!", coins: self.moreDmgCost, index: index, cell: cell)
                }
                
            default:
                print("missed something")
            }
        } else if towerIsSelected {
            switch index {
            case 0:
                presentAlertView(title: "Stone Keep", message: "200 hp for this stone tower.", coins: 1, index: index, cell: cell)
            case 1:
                presentAlertView(title: "Algeroth Tower", message: "500 hp and the glory of Algeroth!", coins: 1, index: index, cell: cell)
            default:
                print("something went wrong here")
            }
        }
    }
    
//    func fetchSomeStats() {
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Upgrades")
//        
//        do {
//            let fetchResult = try self.appDelegate.context.fetch(fetch) as! [Upgrades]
//            fetchResult.first?.damage = 2
//            fetchResult.first?.bouncy = true
//            print("\(fetchResult.first)")
//        }
//        catch {
//            print("error")
//        }
//        
//        do {
//            try self.appDelegate.context.save()
//            
//        }
//        catch {
//            //handle error
//        }
//    }
//    
}








