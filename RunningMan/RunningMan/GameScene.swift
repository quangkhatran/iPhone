//
//  GameScene.swift
//  RunningMan
//
//  Created by Quang Kha Tran on 21/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var runningMan: SKSpriteNode?
    var coinTimer: Timer?
    var bombTimer: Timer?
    var ceil: SKSpriteNode?
    let runningManCategory: UInt32 = 0x1 << 1
    let coinCategory: UInt32 = 0x1 << 2
    let bombCategory: UInt32 = 0x1 << 3
    let groundAndCeilCategory: UInt32 = 0x1 << 4
    var score = 0
    var scoreLabel: SKLabelNode?
    var yourScoreLabel: SKLabelNode?
    var finalScoreLabel: SKLabelNode?
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        runningMan = childNode(withName: "runningMan") as? SKSpriteNode
        runningMan?.physicsBody?.categoryBitMask = runningManCategory
        runningMan?.physicsBody?.contactTestBitMask = coinCategory | bombCategory
        runningMan?.physicsBody?.collisionBitMask = groundAndCeilCategory
        var runningManRun:[SKTexture] = []
        for number in 1...5 {
            runningManRun.append(SKTexture(imageNamed: "frame-\(number)"))
        }
        runningMan?.run(SKAction.repeatForever(SKAction.animate(with: runningManRun, timePerFrame: 0.1)))
        
        ceil = childNode(withName: "ceil") as? SKSpriteNode
        ceil?.physicsBody?.categoryBitMask = groundAndCeilCategory
        ceil?.physicsBody?.collisionBitMask = runningManCategory
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        startTimers()
        createGrass()
    }
    
    func createGrass(){
        let sizingGrass = SKSpriteNode(imageNamed: "grass")
        sizingGrass.setScale(0.2)
        let numberOfGrass = Int(size.width / sizingGrass.size.width)
        for number in 0...numberOfGrass {
            let grass = SKSpriteNode(imageNamed: "grass")
            grass.setScale(0.2)
            grass.physicsBody = SKPhysicsBody(rectangleOf: grass.size)
            grass.physicsBody?.categoryBitMask = groundAndCeilCategory
            grass.physicsBody?.collisionBitMask = runningManCategory
            grass.physicsBody?.affectedByGravity = false
            grass.physicsBody?.isDynamic = false
            addChild(grass)
            
            let grassX = -size.width/2 + grass.size.width/2 + grass.size.width * CGFloat(number)
            grass.position = CGPoint(x: grassX, y: -size.height/2 + grass.size.height/2 - 10)
            let speed = 100.0
            let firstMoveLeft = SKAction.moveBy(x: -grass.size.width/2 - grass.size.width * CGFloat(number+1), y: 0, duration: TimeInterval(grass.size.width/2 + grass.size.width * CGFloat(number+1))/speed )
            let resetGrass = SKAction.moveBy(x: size.width + grass.size.width, y: 0, duration: 0)
            let grassFullMove = SKAction.moveBy(x: -size.width - grass.size.width, y: 0, duration: TimeInterval(size.width + grass.size.width)/speed)
            let grassMovingForever = SKAction.repeatForever(SKAction.sequence([grassFullMove,resetGrass]))
            grass.run(SKAction.sequence([firstMoveLeft,resetGrass,grassMovingForever]))
        }
        
    }
    
    
    func startTimers(){
        coinTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true
            , block: { (timer) in
                self.createCoin()
        })
        
        bombTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true
            , block: { (timer) in
                self.creatBomb()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scene?.isPaused == false {
            runningMan?.physicsBody?.applyForce(CGVector(dx: 0, dy: 100_000))
        }
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let theNodes = nodes(at: location)
            for node in theNodes {
                if node.name == "play" {
                    score = 0
                    node.removeFromParent()
                    yourScoreLabel?.removeFromParent()
                    finalScoreLabel?.removeFromParent()
                    scene?.isPaused = false
                    scoreLabel?.text = "Score: \(score)"
                    startTimers()
                }
            }
        }
    }
    
    func createCoin(){
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.setScale(0.15)
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = runningManCategory
        coin.physicsBody?.collisionBitMask = 0
        addChild(coin)
        
        let sizingGrass = SKSpriteNode(imageNamed: "grass")
        sizingGrass.setScale(0.2)
        let maxY = size.height/2 - coin.size.height/2
        let minY = -size.height/2 + coin.size.height/2 + sizingGrass.size.height
        let range = maxY - minY
        let coinY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        coin.position = CGPoint(x: size.width/2 + coin.size.width/2, y: coinY)
        
        let moveLeft = SKAction.moveBy(x: -size.width - coin.size.width/2, y: 0, duration: 4)
        coin.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
    }
    
    func creatBomb(){
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.setScale(0.12)
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = runningManCategory
        bomb.physicsBody?.collisionBitMask = 0
        addChild(bomb)
        
        let sizingGrass = SKSpriteNode(imageNamed: "grass")
        sizingGrass.setScale(0.2)
        let maxY = size.height/2 - bomb.size.height/2
        let minY = -size.height/2 + bomb.size.height/2 + sizingGrass.size.height
        let range = maxY - minY
        let bombY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        bomb.position = CGPoint(x: size.width/2 + bomb.size.width/2, y: bombY)
        
        let moveLeft = SKAction.moveBy(x: -size.width - bomb.size.width/2, y: 0, duration: 4)
        bomb.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == coinCategory {
            contact.bodyA.node?.removeFromParent()
            score += 1
            scoreLabel!.text = "Score: \(score)"
        }
        if contact.bodyB.categoryBitMask == coinCategory {
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel!.text = "Score: \(score)"
        }
        
        if contact.bodyA.categoryBitMask == bombCategory {
            contact.bodyA.node?.removeFromParent()
            gameOver()
        }
        if contact.bodyB.categoryBitMask == bombCategory {
            contact.bodyB.node?.removeFromParent()
            gameOver()
        }
    }
    
    func gameOver(){
        scene?.isPaused = true
        
        coinTimer?.invalidate()
        bombTimer?.invalidate()
        
        yourScoreLabel = SKLabelNode(text: "Your Score:")
        yourScoreLabel!.position = CGPoint(x: 0, y: 200)
        yourScoreLabel!.fontSize = 50
        yourScoreLabel?.zPosition = 1
        addChild(yourScoreLabel!)
        
        finalScoreLabel = SKLabelNode(text: "\(score)")
        finalScoreLabel!.position = CGPoint(x: 0, y: 0)
        finalScoreLabel!.fontSize = 100
        finalScoreLabel?.zPosition = 1
        addChild(finalScoreLabel!)
        
        let playButton = SKSpriteNode(imageNamed: "play")
        playButton.setScale(0.5)
        playButton.position = CGPoint(x: 0, y: -200)
        playButton.name = "play"
        playButton.zPosition = 1
        addChild(playButton)
        
    }
   
    
    
}
