//
//  GameScene.swift
//  Final651
//
//  Created by WeiGuangcheng on 5/8/16.
//  Copyright (c) 2016 Guangcheng Wei. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // player sprite
    let player = SKSpriteNode(imageNamed:"ship")
    // start label
    let startLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    // state, 0 for not start, 1 for started
    var state = 0
    
    // player life
    var life = 3
    // enemy left
    var enemyLeft = 3
    // enemy to spawn
    var enemyToSpawn = 3
    // score
    var score = 0
    
    
    var controller:GameViewController!
    
    // construct collision masks
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Player    : UInt32 = 0b1
        static let Enemy     : UInt32 = 0b10
        static let Obstacle  : UInt32 = 0b100
        static let EnemyOrObstacle : UInt32 = 0b110
    }
    
    // setup player
    func initPlayer(){
        player.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame))
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        // collision with enemy or obstacle
        player.physicsBody?.contactTestBitMask = PhysicsCategory.EnemyOrObstacle
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(player)
    }
    
    // setup start label
    func initStartLabel(){
        startLabel.text = "Press to Start!"
        startLabel.fontSize = 45
        startLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(startLabel)
    }
    
    // random with arc4random
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    // random with range
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addEnemy(){
        if(state == 0 || enemyToSpawn <= 0) {return}
        enemyToSpawn -= 1
        // create sprite
        let enemy = SKSpriteNode(imageNamed: "enemy")
        
        // create physics body
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.dynamic = true // 2
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        // collision with player
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // where to spawn the obstacle along the X axis
        let actualX = random(min: enemy.size.width/2, max: size.width - enemy.size.width/2)
        
        // put enemy on top
        enemy.position = CGPoint(x: actualX, y: size.height + enemy.size.height/2)
        
        // add obstacle to the scene
        addChild(enemy)
        
        // get speed
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // move to bottom
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -enemy.size.height/2), duration: NSTimeInterval(actualDuration))
        // remove after finish move
        let actionMoveDone = SKAction.removeFromParent()
        // run action, after removed, call avoidEnemyScore
        enemy.runAction(SKAction.sequence([actionMove, actionMoveDone, SKAction.runBlock(avoidEnemyScore)]))
    }
    // get score by avoid enemy
    func avoidEnemyScore(){
        // 5 score for each
        score += 5
        // left enemy decrese
        enemyLeft -= 1
        print("score: \(score)")
        // if no enemy left
        if enemyLeft == 0 {
            // win
            win()
        }
    }
    func addObstacle(){
        // when not start, return
        if(state == 0) {return}
        // create sprite
        let obstacle = SKSpriteNode(imageNamed: "obstacle")
        
        // create physics body
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: obstacle.size)
        obstacle.physicsBody?.dynamic = true
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        // collision with player
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        obstacle.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // where to spawn the obstacle along the X axis
        let actualX = random(min: obstacle.size.width/2, max: size.width - obstacle.size.width/2)
        
        // put obstacle on top
        obstacle.position = CGPoint(x: actualX, y: size.height + obstacle.size.height/2)
        
        // add obstacle to the scene
        addChild(obstacle)
        
        // get speed
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // move to bottom
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -obstacle.size.height/2), duration: NSTimeInterval(actualDuration))
        // remove after finish move
        let actionMoveDone = SKAction.removeFromParent()
        // run action
        obstacle.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // if collision with enemy
    func playerDidCollisionWithEnemy(player:SKSpriteNode, enemy:SKSpriteNode){
        // deduct life by 1
        life -= 1
        // if life less or equal than 0
        if life <= 0 {
            // lose
            lose()
        }
    }
    
    // lose if collision with obstacle
    func playerDidCollisionWithObstacle(player:SKSpriteNode, obstacle:SKSpriteNode){
        lose()
    }
    
    // when lose
    func lose(){
        print("lose")
        // stop all actions
        removeAllActions()
        // remove player, enemy and obstacle
        removeAllChildren()
        // tell controller the result
        self.controller.result(score, win:false)
    }
    
    func win(){
        print("win")
        // stop all actions
        removeAllActions()
        // remove player, enemy and obstacle
        removeAllChildren()
        // tell controller the result
        self.controller.result(score, win:true)
    }
    
    // when collision
    func didBeginContact(contact: SKPhysicsContact) {
        // define first body and second body
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // make first body have smaller categoryBitMask
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // if player collision with enemy
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Enemy != 0)) {
            print("contact player -> enemy")
            // call playerDidCollisionWithEnemy
            playerDidCollisionWithEnemy(firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
        }
        // if player collision with obstacle
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Obstacle != 0)) {
            print("contact player -> obstacle")
            // call playerDidCollisionWithObstacle
            playerDidCollisionWithObstacle(firstBody.node as! SKSpriteNode, obstacle: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    //when start
    override func didMoveToView(view: SKView) {
        // set physics delegate
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        // set up data of this gameplay
        life = 3
        enemyToSpawn = 3 * controller.level
        enemyLeft = enemyToSpawn
        score = controller.lastScore
        
        // init player
        initPlayer()
        // init start label
        initStartLabel()
        // repeat generate enemy with time interval 1s
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addEnemy),
                SKAction.waitForDuration(1.0)
                ])
            ))
        // repeat generate obstacle with time interval 3s
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addObstacle),
                SKAction.waitForDuration(3.0)
                ])
            ))
    }
    
    // Player speed
    let PLAYER_SPEED:Double = 1000
    
    // when touch began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // get touch
        let touch = touches.first
        // when not started
        if(state == 0) {
            // hide label
            startLabel.hidden = true
            // start
            state = 1
        }
        // stop current action of player
        player.removeAllActions()
        // detect touch location
        let location = touch!.locationInNode(self)
        // calculate distance
        let distance = abs(Double(player.position.x - location.x))
        // set up move action
        let move = SKAction.moveToX(location.x, duration: distance/PLAYER_SPEED)
        // move player
        player.runAction(move)
    
    }
    
    // when touch moved
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // get touch
        let touch = touches.first
        // stop current action of player
        player.removeAllActions()
        // detect touch location
        let location = touch!.locationInNode(self)
        // calculate distance
        let distance = abs(Double(player.position.x - location.x))
        // set up move action
        let move = SKAction.moveToX(location.x, duration: distance/PLAYER_SPEED)
        // move player
        player.runAction(move)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
