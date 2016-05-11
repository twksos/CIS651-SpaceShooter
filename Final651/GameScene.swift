//
//  GameScene.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/8/16.
//  Copyright (c) 2016 Guangcheng Wei. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed:"Spaceship")
    let startLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    var controller:GameViewController!
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Player    : UInt32 = 0b1       // 1
        static let Enemy     : UInt32 = 0b10      // 2
    }
    
    func initPlayer(){
        player.xScale = 0.5
        player.yScale = 0.5
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame))
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
    }
    
    func initStartLabel(){
        startLabel.text = "Press to Start!"
        startLabel.fontSize = 45
        startLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(startLabel)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addEnemy(){
        // Create sprite
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size) // 1
        enemy.physicsBody?.dynamic = true // 2
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy // 3
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Player // 4
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        // Determine where to spawn the monster along the Y axis
        let actualX = random(min: enemy.size.height/2, max: size.height - enemy.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        enemy.position = CGPoint(x: actualX, y: size.height + enemy.size.height/2)
        
        // Add the monster to the scene
        addChild(enemy)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: enemy.size.height/2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    func addObstacle(){}
    
    func playerDidCollisionWithEnemy(player:SKSpriteNode, enemy:SKSpriteNode){
        removeAllActions()
        removeAllChildren()
        self.controller.result()
        print("lose")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        print("contact")
        print(firstBody.categoryBitMask)
        print(secondBody.categoryBitMask)
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Enemy != 0)) {
            playerDidCollisionWithEnemy(firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        /* Setup your scene here */
        initPlayer()
        initStartLabel()
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemy),
                SKAction.waitForDuration(1.0)
                ])
            ))
    }
    
    let PLAYER_SPEED:Double = 50
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            player.removeAllActions()
            startLabel.hidden = true
            let location = touch.locationInNode(self)
            let distance = abs(Double(player.position.x - location.x))
            let move = SKAction.moveToX(location.x, duration: distance/PLAYER_SPEED)
            player.runAction(move)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
