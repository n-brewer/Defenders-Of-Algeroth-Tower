//
//  GameOverVC.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/21/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import UIKit
import GameplayKit

class GameOverVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var myView: SKView!
    @IBOutlet weak var actionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designViews(view: bgView, button1: homeBtn, button2: retryBtn)
    }

    func designViews(view: UIView, button1: UIButton, button2: UIButton) {
        view.layer.cornerRadius = 8.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowOpacity = 1.0
        
        button1.layer.cornerRadius = 8.0
        button1.layer.shadowColor = UIColor.black.cgColor
        button1.layer.shadowRadius = 2.0
        button1.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        button1.layer.shadowOpacity = 0.8
        
        button2.layer.cornerRadius = 8.0
        button2.layer.shadowColor = UIColor.black.cgColor
        button2.layer.shadowRadius = 2.0
        button2.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        button2.layer.shadowOpacity = 0.8
    }
    
//    @IBAction func retryBtnTapped(_ sender: UIButton) {
////        actionView.removeFromSuperview()
//        let scene = GKScene(fileNamed: "PlayScene")
//        let sceneNode = scene?.rootNode as! PlayScene?
//        sceneNode?.scaleMode = .aspectFill
//        sceneNode?.wave1()
//        self.resignFirstResponder()
////        let skView = self.view as! SKView
////        skView.ignoresSiblingOrder = true
////        skView.presentScene(sceneNode)
//        self.dismiss(animated: true, completion: nil)
//    }
}
