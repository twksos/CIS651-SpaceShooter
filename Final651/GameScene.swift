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
    var life = 3
    var enemyLeft = 30
    var score = 0
    
    var controller:GameViewController!
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Player    : UInt32 = 0b1
        static let Enemy     : UInt32 = 0b10
        static let Obstacle  : UInt32 = 0b100
        static let EnemyOrObstacle : UInt32 = 0b110
    }
    
    func initPlayer(){
        player.xScale = 0.5
        player.yScale = 0.5
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame))
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.EnemyOrObstacle
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
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -enemy.size.height/2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([actionMove, actionMoveDone, SKAction.runBlock(avoidEnemyScore)]))
    }
    func avoidEnemyScore(){
        score += 5
        enemyLeft -= 1
        print("score: \(score)")
        if enemyLeft == 0 {
            win()
        }
    }
    func addObstacle(){
        // Create sprite
        let obstacle = SKSpriteNode(imageNamed: "obstacle")
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle.size) // 1
        obstacle.physicsBody?.dynamic = true // 2
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle // 3
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Player // 4
        obstacle.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        // Determine where to spawn the monster along the Y axis
        let actualX = random(min: obstacle.size.height/2, max: size.height - obstacle.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        obstacle.position = CGPoint(x: actualX, y: size.height + obstacle.size.height/2)
        
        // Add the monster to the scene
        addChild(obstacle)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -obstacle.size.height/2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        obstacle.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func playerDidCollisionWithEnemy(player:SKSpriteNode, enemy:SKSpriteNode){
        life -= 1
        if life <= 0 {
            lose()
        }
    }
    
    func playerDidCollisionWithObstacle(player:SKSpriteNode, obstacle:SKSpriteNode){
        lose()
    }
    
    func lose(){
        removeAllActions()
        removeAllChildren()
        self.controller.result(score, win:false)
        print("lose")
    }
    
    func win(){
        print("win")
        removeAllActions()
        removeAllChildren()
        self.controller.result(score, win:true)
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
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Enemy != 0)) {
            print("contact player -> enemy")
            playerDidCollisionWithEnemy(firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Obstacle != 0)) {
            print("contact player -> obstacle")
            playerDidCollisionWithObstacle(firstBody.node as! SKSpriteNode, obstacle: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        /* Setup your scene here */
        life = 3
        enemyLeft = 3 * controller.level
        score = 0
        print("emenyLeft: \(enemyLeft)")
        initPlayer()
        initStartLabel()
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemy),
                SKAction.waitForDuration(1.0)
                ])
            ))
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addObstacle),
                SKAction.waitForDuration(3.0)
                ])
            ))
    }
    
    let PLAYER_SPEED:Double = 1000
    
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
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
