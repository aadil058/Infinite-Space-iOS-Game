//
//  mainMenu.swift
//  infiniteSpace
//
//  Created by Mohd Aadil on 10/4/15.
//  Copyright © 2015 AMAdev. All rights reserved.
//

import SpriteKit

class mainMenu : SKScene {
    var label : SKLabelNode!
    var play : SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.blackColor()
        
        label = SKLabelNode(fontNamed: "Copperplate")
        label.fontSize = 50
        label.text = "Infinite Space"
        label.position = CGPointMake(view.bounds.width / 2,view.bounds.height * 0.8)
        addChild(label)
        
        play = SKSpriteNode(imageNamed: "play")
        play.position = CGPointMake(view.bounds.width / 2, view.bounds.height * 0.6)
        play.name = "PLAYBUTTON"
        self.addChild(play!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let Node : SKNode = nodeAtPoint(location)
            if Node.name == "PLAYBUTTON"{
                if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
                
                // Configure the view.
                let skView = view as! SKView!
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                skView.showsPhysics = false
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .ResizeFill
                
                skView.presentScene(scene)
                }
            }
        
        }
    }
}