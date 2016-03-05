//
//  gameOver.swift
//  infiniteSpace
//
//  Created by Mohd Aadil on 10/3/15.
//  Copyright © 2015 AMAdev. All rights reserved.
//

import SpriteKit

class gameOver : SKScene {
    
    var highScore = NSUserDefaults.standardUserDefaults().integerForKey("score")
    var label : SKLabelNode!
    var Score : SKLabelNode!
    var best : SKLabelNode!
    var playAgain : SKSpriteNode!
    
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
    }
    
    init(size: CGSize,score : Int) {
        super.init(size: size)
        backgroundColor = SKColor.blackColor()
        
        label = SKLabelNode(fontNamed : "Copperplate")
        Score = SKLabelNode(fontNamed : "Copperplate")
        best = SKLabelNode(fontNamed: "Copperplate")
        
        label.fontSize = 50
        label.fontColor = SKColor.whiteColor()
        label.text = "Game Over"
        label.position = CGPointMake(size.width / 2, size.height * 0.8)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        Score.fontSize = 25
        Score.fontColor = SKColor.whiteColor()
        Score.text = "Score : \(score)"
        Score.position = CGPointMake(size.width / 2, size.height * 0.6)
        Score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        best.fontSize = 25
        best.fontColor = SKColor.whiteColor()
        if score > highScore {
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "score")
            NSUserDefaults.standardUserDefaults().synchronize()
            highScore = NSUserDefaults.standardUserDefaults().integerForKey("score")
        }
        best.text = "Best : \(highScore)"
        best.position = CGPointMake(size.width / 2, size.height * 0.5)
        best.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        
        
        playAgain = SKSpriteNode(imageNamed: "playagain")
        playAgain.position = CGPointMake(size.width / 2, size.height * 0.3)
        playAgain.name = "PLAYAGAIN"
        
        
        
        addChild(playAgain)
        addChild(label)
        addChild(Score)
        addChild(best)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch : AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let Node : SKNode = nodeAtPoint(location)
            if Node.name == "PLAYAGAIN"{
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