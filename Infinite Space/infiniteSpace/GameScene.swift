//
//  GameScene.swift
//  infiniteSpace
//
//  Created by Mohd Aadil on 10/2/15.
//  Copyright (c) 2015 AMAdev. All rights reserved.
//

import SpriteKit

class GameScene: SKScene , SKPhysicsContactDelegate {
    
    var Background : SKSpriteNode!
    var spaceShip : SKSpriteNode!
    
    var Fuel : SKSpriteNode!
    var curFuelPos : CGFloat = 400.0
    var xFuelPos : Int = 0
    
    var Asteroid : SKSpriteNode!
    var foreGroundAsteroid : SKNode!
    var curAsteroidPos : CGFloat = 500.0
    var xAsteroidPos : CGFloat = 0.0
    
    var foreGround : SKNode!
    var foreGroundY : CGFloat = 0.0
    
    var backgroundMove : SKAction!
    
    var action1 : SKAction!
    var action2 : SKAction!
    var wait : SKAction!
    var move : SKAction!
    
    var screenTouch : Bool = false
    var touchCount : Int = 0
    
    var scoreCard : SKLabelNode!
    var damage : SKLabelNode!
    var score : Int = 0
    
    var blackHole : SKSpriteNode!
    var xBlackHole : CGFloat = 0.0
    var lastBlackHole : Int = 500
    
    var collisionCategorySpaceShip : UInt32 = 0x1 << 1
    var collisionCategoryFuel : UInt32 = 0x1 << 2
    var collisionCategoryAsteroid : UInt32 = 0x1 << 3
    var collisionCategoryBlackHole : UInt32 = 0x1 << 4
  
    
    var tapAnywhere : SKLabelNode!
    var start : Bool = false
    
    var collisionCount = 3
    var foreGroundText : SKNode!
    
    override func didMoveToView(view: SKView) {
    
    /*************************************************************/
    /******************* Additional Settings *********************/
        
        physicsWorld.gravity = CGVectorMake(0.0,0.0)
        userInteractionEnabled = true
        physicsWorld.contactDelegate = self
        var size = view.bounds.size
        
    
    /*************************************************************/
    /******************* Background Setting **********************/
        
       addBackground()
      // backgroundColor = SKColor.blackColor()
        
    /*************************************************************/
    /****************** foreGround Setting ***********************/
        
        foreGround = SKNode()
        self.addChild(foreGround)
        
        
    /*************************************************************/
    /******************** spaceShip Setting **********************/
        
        addSpaceShip()
        
    /*************************************************************/
    /********************* Fuel Setting **************************/
        
        addFuel()
        
    /*************************************************************/
    /********************* Asteroid Setting **********************/
        
        foreGroundAsteroid = SKNode()
        self.addChild(foreGroundAsteroid)
        addAsteroid()
        
       
    /*************************************************************/
    /******************** Blackhole Setting **********************/
        
        addBlackHoles()
     
    /**************************************************************/
    /******************** Tap Anywhere To Start *******************/
        
        addTapAnyWhere()
        
        
    /**************************************************************/
    /*******************    score and damage board ****************/
        
        addScoreCard()
        addDamage()
        
    }
    
    
    
// addBackground Method
    
    func addBackground() {
        Background = SKSpriteNode(imageNamed: "Background1")
        Background.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        Background.position = CGPoint(x: size.width / 2.0, y: 0.0)
        Background.size.width = size.width
        
       // backgroundMove = SKAction.sequence([SKAction.moveToY(-1280.0, duration: 15.0),SKAction.moveToY(0.0, duration: 0.0)])
       // Background.runAction(SKAction.repeatActionForever(backgroundMove))
        self.addChild(Background)
    }
    
// addSpaceShip Method
    
    func addSpaceShip() {
        spaceShip = SKSpriteNode(imageNamed: "ship1")
        spaceShip.position = CGPoint(x: size.width / 2.0, y : size.width / 3.0)
        spaceShip.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(40, 115))
        spaceShip.physicsBody!.dynamic = false
        spaceShip.physicsBody!.categoryBitMask = collisionCategorySpaceShip
        spaceShip.physicsBody!.contactTestBitMask = collisionCategoryFuel | collisionCategoryBlackHole | collisionCategoryAsteroid
        spaceShip.physicsBody!.collisionBitMask = 0
        addChild(spaceShip)
    }
 

// addScoreCard Method
    
    func addScoreCard() {
        scoreCard = SKLabelNode(fontNamed: "Chalkduster")
        scoreCard.fontSize = 20
        scoreCard.position = CGPointMake(size.width - 100 , size.height - 25)
        scoreCard.text = "score : \(score)"
        scoreCard.zPosition = 100
        addChild(scoreCard)
    }
    
// addDamage Method
    
    func addDamage() {
        damage = SKLabelNode(fontNamed: "Chalkduster")
        damage.fontSize = 20
        damage.position = CGPointMake(90, size.height - 25)
        damage.text = "Strength : \(collisionCount)"
        damage.zPosition = 100
        addChild(damage)
    }
    
    
    
// addFuel Method
    
    func addFuel() {
        for _ in 1...100 {
            Fuel = SKSpriteNode(imageNamed : "Fuel")
            xFuelPos = Int(arc4random_uniform(UInt32(size.width)))
            
            if xFuelPos > Int(((size.width) - (Fuel!.size.width / 2.0))) {
                xFuelPos = xFuelPos - Int((Fuel!.size.width / 2.0))
            }
            else if xFuelPos < Int(Fuel!.size.width/2) {
                xFuelPos += Int(Fuel!.size.width)
            }
            
            
            Fuel.position = CGPoint(x: CGFloat(xFuelPos), y: curFuelPos)
            curFuelPos += CGFloat(arc4random_uniform(UInt32(Fuel.size.width)) + UInt32((Fuel.size.width * 3)) + 100)
            Fuel.physicsBody = SKPhysicsBody(circleOfRadius: Fuel.size.width / 2.0)
            Fuel.physicsBody!.dynamic = true
            Fuel.physicsBody!.pinned = true
            Fuel.physicsBody!.affectedByGravity = false
            Fuel.name = "FUEL"
            Fuel.physicsBody!.categoryBitMask = collisionCategoryFuel
            Fuel.physicsBody!.contactTestBitMask = collisionCategorySpaceShip
            Fuel.physicsBody!.collisionBitMask = 0
            foreGround.addChild(Fuel)
        }
    }
    
// touchesBegan Method
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
        
        if start == false{
            start = true
            tapAnywhere.removeFromParent()
            action1 = SKAction.moveToY(spaceShip.position.y + 50, duration: 2)
            spaceShip.runAction(action1)
            screenTouch = true
            runForeGround()
            foreGroundAsteroid.runAction(SKAction.moveToY(-1000000000, duration: 1000000 * 6))
            }
            
        
            ++touchCount
            
            if(touchCount > 0) {
               moveSpaceShip(location.x)
            }
            
        }
    }
    
// addTapAnyWhere Method
    
    func addTapAnyWhere() {
        tapAnywhere = SKLabelNode(fontNamed: "Copperplate")
        tapAnywhere.text = "TAP ANYWHERE TO START"
        tapAnywhere.fontColor = SKColor.whiteColor()
        tapAnywhere.fontSize = 20
        tapAnywhere.position = CGPoint(x: size.width * 0.5, y: size.height *  0.4)
        tapAnywhere.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        tapAnywhere.zPosition = 100
        addChild(tapAnywhere)
    }
    

// moveSpaceShip
    
    func moveSpaceShip(x : CGFloat) {
     spaceShip.runAction(SKAction.moveToX(x, duration: 0.3))
    }
    
    
    
// runForeGround Method
    
    func runForeGround() {
        foreGroundY = (curFuelPos + 100)
        action1 = SKAction.moveToY(-foreGroundY, duration: (Double(145)))  // 200
        foreGround.runAction(action1)
    }
    
// addAsteroid Method
    
    func addAsteroid() {
        for _ in 1...100 {
            Asteroid = SKSpriteNode(imageNamed: "asteroidSmall")
            Asteroid.physicsBody = SKPhysicsBody(circleOfRadius: Asteroid.size.width / 2.0)
            Asteroid.physicsBody!.dynamic = true
            Asteroid.physicsBody!.affectedByGravity = false
            
            Asteroid.physicsBody!.categoryBitMask = collisionCategoryAsteroid
            Asteroid.physicsBody!.contactTestBitMask = collisionCategorySpaceShip
            Asteroid.physicsBody!.collisionBitMask = collisionCategorySpaceShip
      
            asteroidPosition()
            
            Asteroid.position = CGPoint(x: xAsteroidPos, y: curAsteroidPos)
            curAsteroidPos += CGFloat(arc4random_uniform(100) + 500)
            
            asteroidAction()
            
            Asteroid.name = "ASTEROID"
            Asteroid.runAction(move)
            foreGroundAsteroid.addChild(Asteroid)
        }
    }
    
// addBlackHoles Method
    
    func addBlackHoles() {
        var i = 0
        for i = lastBlackHole ; i <= Int(curFuelPos) ; i = i + (Int(size.height) * 2) {
           blackHole = SKSpriteNode(imageNamed: "BlackHole")
           blackHole.position = CGPointMake(xcord(),CGFloat(arc4random_uniform(UInt32(size.height))) + CGFloat(i))
           blackHole.name = "BLACKHOLE"
            
           blackHole.physicsBody = SKPhysicsBody(circleOfRadius: blackHole.size.width / 2)
            
           blackHole.physicsBody!.categoryBitMask = collisionCategoryBlackHole
           blackHole.physicsBody!.contactTestBitMask = collisionCategorySpaceShip
           blackHole.physicsBody!.collisionBitMask = 0
           
            
           foreGround.addChild(blackHole)
        }
        lastBlackHole = i - Int(size.height)
    }

// xcord Method
    
    func xcord() -> CGFloat {
        xBlackHole = CGFloat(arc4random_uniform(UInt32(size.width)))
        
        if xBlackHole - blackHole.size.width < 0 {
            xBlackHole = xBlackHole + blackHole.size.width
        }
        else if xBlackHole + blackHole.size.width > size.width{
            xBlackHole = xBlackHole - blackHole.size.width
        }
        
        return xBlackHole
    }
    
    
// asteroidPosition Method
    
    func asteroidPosition() {
        xAsteroidPos = CGFloat(arc4random_uniform(UInt32(size.width)))
        
        
        if xAsteroidPos < size.width / 2.0 {
          xAsteroidPos = (0.0 - Asteroid.size.width)
        }
        else if xAsteroidPos > size.width / 2.0 {
            xAsteroidPos = (size.width + Asteroid.size.width)
        }
        
    }
    
// asteroidAction Method
    
    func asteroidAction() {
        if xAsteroidPos < 0 {
            action1 = SKAction.moveToX(size.width + Asteroid.size.width, duration: 2.4)
            wait = SKAction.waitForDuration(2)
            action2 = SKAction.moveToX(0.0 - Asteroid!.size.width,duration : 2.4)
            move = SKAction.repeatActionForever(SKAction.sequence([action1,wait,action2]))
        }
        else{
            action1 = SKAction.moveToX(0.0 - Asteroid!.size.width, duration: 2.4)
            wait = SKAction.waitForDuration(2)
            action2 = SKAction.moveToX(size.width + Asteroid!.size.width, duration: 2.4)
            move = SKAction.repeatActionForever(SKAction.sequence([action1,wait,action2]))
        }
        
    }
    
    
// didBeginContact Method
    
    func didBeginContact(contact: SKPhysicsContact) {
        let Node = contact.bodyB.node!
        
        if Node.name == "FUEL" {
            ++score
            scoreCard.text = "score : \(score)"
            scoreCard.removeFromParent()
            addScoreCard()
                
        
            Node.removeFromParent()
        }
    
    
    
        else if Node.name == "ASTEROID" {
           --collisionCount
            damage.text = "Strength : \(collisionCount)"
            damage.removeFromParent()
            addDamage()
            
            if collisionCount == 0 {
                let transition = SKTransition.flipHorizontalWithDuration(0)
                let GameOver = gameOver(size: size,score: score)
                view!.presentScene(GameOver, transition: transition)
            }
        }
        else if Node.name == "BLACKHOLE" {
            let transition = SKTransition.flipHorizontalWithDuration(0)
            let GameOver = gameOver(size: size,score: score)
            view!.presentScene(GameOver, transition: transition)
        }
    }
    
   
// update Method
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        scoreCard.text = "score : \(score)"
        damage.text = "Strength : \(collisionCount)"
        
        if curFuelPos - abs(foreGround.position.y) < 736 {
            addFuel()
            addBlackHoles()
            runForeGround()
       }
        
        if curAsteroidPos - abs(foreGroundAsteroid.position.y) < 736 {
            addAsteroid()
        }
    }
}
