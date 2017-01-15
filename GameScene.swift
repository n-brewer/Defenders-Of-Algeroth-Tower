//
//  GameScene.swift
//  Guardians Of Algeroth Tower
//
//  Created by Nathan Brewer on 1/13/17.
//  Copyright © 2017 Nathan Brewer. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    
    override func didMove(to view: SKView) {
    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let play = childNode(withName: "play")
        let fade = SKAction.fadeOut(withDuration: 1.0)
        
        play?.run(fade, completion: {
            let doors = SKTransition.doorway(withDuration: 1.0)
            let playScene = PlayScene(fileNamed: "PlayScene")
            playScene?.scaleMode = .aspectFill
            self.view?.presentScene(playScene!, transition: doors)
        })
        

        }
     
    
    
    override func update(_ currentTime: TimeInterval) {
        
       }
    
    }



















