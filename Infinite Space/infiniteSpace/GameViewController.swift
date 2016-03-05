//
//  GameViewController.swift
//  infiniteSpace
//
//  Created by Mohd Aadil on 10/2/15.
//  Copyright (c) 2015 AMAdev. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode
{
    class func unarchiveFromFile(file : String) -> SKNode?
    {
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        let sceneData : NSData?
        
        do
        {
            sceneData = try NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe)
        }
        catch _ {
            sceneData = nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData!)
        
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
        
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //   if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
           let scene = mainMenu()

            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            skView.showsPhysics = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
    //   }
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

