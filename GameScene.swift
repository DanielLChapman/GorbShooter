//
//  GameScene.swift
//  SwiftKitSkip
//
//  Created by Daniel Chapman on 11/11/14.
//  Copyright (c) 2014 Daniel Chapman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var hero:Hero!
    var touchLocation = CGFloat()
    var gameOver = false
    var endOfScreenRight = CGFloat()
    var endOfScreenLeft = CGFloat()
    var badGuys:[BadGuy] = []
    var particles:[Particle] = []
    var scoreLabel = SKLabelNode()
    var score = 0
    var refresh = SKSpriteNode(imageNamed: "refresh")
    var timer = NSTimer()
    var countDownText = SKLabelNode(text: "5")
    var countDown = 5
    var updated = false
    var addedBadGuys = false
    
    enum ColliderType:UInt32 {
        case Hero = 1
        case BadGuy = 2
        case Particle = 3
    }
    
    func reloadGame() {
        for particle in particles {
            particle.guy.hidden = true
        }
        particles = []
        countDownText.hidden = false
        hero.guy.position.y = 0
        hero.guy.position.x = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        refresh.hidden = true
    }
    
    func updateTimer() {
        if countDown > 0 {
            countDown--
            countDownText.text = String(countDown)
        } else {
            countDown = 5
            countDownText.text = String(countDown)
            countDownText.hidden = true
            gameOver = false
            timer.invalidate()
            addBadGuys()
        }
    }
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        endOfScreenLeft = (self.size.width / 2) * (CGFloat(-1))
        endOfScreenRight = (self.size.width / 2)
        addBG()
        addJeff()
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position.y = -(self.size.height/4)
        addChild(scoreLabel)
        addChild(countDownText)
        countDownText.hidden = true
        addChild(refresh)
        refresh.name = "refresh"
        refresh.hidden = true
        
    }
    
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if !(contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask) {
            if (contact.bodyA.categoryBitMask) == 1 || (contact.bodyA.categoryBitMask) == 2 {
                if (contact.bodyB.categoryBitMask) == 2 || (contact.bodyB.categoryBitMask) == 1 {
                    hero.emit = true
                    gameOver = true
                    refresh.hidden = false
                }
            }
            if (contact.bodyA.categoryBitMask) == 2 || (contact.bodyA.categoryBitMask) == 3 {
                if (contact.bodyB.categoryBitMask) == 3 || (contact.bodyB.categoryBitMask) == 2 {
                    updateScore()
                    for particle in particles {
                        if particle.guy.position.x == contact.bodyA.node?.position.x && particle.guy.position.y == contact.bodyA.node?.position.y {
                            particle.guy.hidden = true
                            particle.guy.removeFromParent()
                            
                        }
                        if particle.guy.position.x == contact.bodyB.node?.position.x && particle.guy.position.y == contact.bodyB.node?.position.y {
                            particle.guy.hidden = true
                            particle.guy.removeFromParent()
                        }
                    }
                    for BadGuy in badGuys {
                        
                        if BadGuy.guy.name == contact.bodyB.node?.name {
                            BadGuy.guy.hidden = true
                            BadGuy.guy.removeFromParent()
                            if let index = (self.badGuys as NSArray).indexOfObject(BadGuy) as Int? {
                                self.badGuys.removeAtIndex(index)
                            }
                            
                        }
                        else if BadGuy.guy.name == contact.bodyA.node?.name {
                            BadGuy.guy.hidden = true
                            BadGuy.guy.removeFromParent()
                            if let index = (self.badGuys as NSArray).indexOfObject(BadGuy) as Int? {
                                self.badGuys.removeAtIndex(index)
                            }
                            
                        }
                    }
                }
            }
        }
        if (badGuys.count == 0) {
            gameOver = true
            refresh.hidden = false
        }
    }
    
    func addJeff() {
        let jeff = SKSpriteNode(imageNamed: "jeff")
        jeff.physicsBody = SKPhysicsBody(circleOfRadius: jeff.size.width/2)
        jeff.physicsBody!.affectedByGravity = false
        jeff.physicsBody!.categoryBitMask = ColliderType.Hero.rawValue
        jeff.physicsBody!.contactTestBitMask = ColliderType.BadGuy.rawValue
        jeff.physicsBody!.collisionBitMask = ColliderType.BadGuy.rawValue
        let heroParticles = SKEmitterNode(fileNamed: "HitParticle.sks")
        heroParticles.hidden = true
        hero = Hero(guy: jeff, particles: heroParticles)
        jeff.addChild(heroParticles)
        addChild(jeff)
        
    }
    
    func addBadGuys() {
        addBadGuy(named: "natasha", speed: 3.0, yPos: CGFloat(self.size.height/4))
        addBadGuy(named: "boris", speed: 3.5, yPos: CGFloat(0))
        addBadGuy(named: "paul", speed: 2.0, yPos: CGFloat(-1 * self.size.height/4))
        
    }
    
    func shoot(targetX: CGFloat, targetY: CGFloat) {
        var particleNode = SKSpriteNode(imageNamed:"projectile")
        particleNode.physicsBody = SKPhysicsBody(circleOfRadius: particleNode.size.width/2)
        particleNode.physicsBody!.affectedByGravity = false
        particleNode.physicsBody!.categoryBitMask = ColliderType.Particle.rawValue
        particleNode.physicsBody!.contactTestBitMask = ColliderType.BadGuy.rawValue
        particleNode.physicsBody!.collisionBitMask = ColliderType.BadGuy.rawValue
        var particleFired = Particle(speed:0.7, guy: particleNode, targetX: targetX, targetY: targetY)
        particles.append(particleFired)
        particleNode.position.x = 0
        particleNode.position.y = 0
        addChild(particleNode)
        particleFired.fire()
    }
    
    func resetParticle(badGuyNode:SKSpriteNode) {
        badGuyNode.position.x = 0
        badGuyNode.position.y = 0
        badGuyNode.hidden=true
    }
    
    func addBadGuy(#named:String, speed:Float, yPos:CGFloat) {
        var badGuyNode = SKSpriteNode(imageNamed: named)
        badGuyNode.name = named
        badGuyNode.physicsBody = SKPhysicsBody(circleOfRadius: badGuyNode.size.width/2)
        badGuyNode.physicsBody!.affectedByGravity = false
        badGuyNode.physicsBody!.categoryBitMask = ColliderType.BadGuy.rawValue
        badGuyNode.physicsBody!.contactTestBitMask = ColliderType.Hero.rawValue | ColliderType.Particle.rawValue
        badGuyNode.physicsBody!.collisionBitMask = ColliderType.Hero.rawValue | ColliderType.Particle.rawValue
        
        
        var badGuy = BadGuy(speed: speed, guy: badGuyNode)
        badGuys.append(badGuy)
        resetBadGuy(badGuyNode, yPos: yPos)
        badGuy.yPos = badGuyNode.position.y
        addChild(badGuyNode)
        badGuy.fire()
    }
    
    func resetBadGuy(badGuyNode:SKSpriteNode, yPos:CGFloat) {
        badGuyNode.position.x = endOfScreenRight
        badGuyNode.position.y = yPos
    }
    
    func addBG() {
        let bg = SKSpriteNode(imageNamed: "bg")
        addChild(bg)
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        
        for touch: AnyObject in touches {
            if !gameOver {
                touchLocation = (self.size.height/2) + (touch.locationInView(self.view!).y * -1)
                let location = touch.locationInNode(self)
                shoot(location.x, targetY: location.y)
                
            } else {
                let location = touch.locationInNode(self)
                var sprites = nodesAtPoint(location)
                for sprite in sprites {
                    if let spriteNode = sprite as? SKSpriteNode {
                        if spriteNode.name != nil {
                            if spriteNode.name == "refresh" {
                                reloadGame()
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if !gameOver {
            if (!updated && score != 0 && ((score % 4) == 0)) {
                //var r = Int(arc4random_uniform(3) + 1)
                updated = true
            }
        }
        updateHeroEmitter()
        if (!addedBadGuys) {
            addBadGuys()
            addedBadGuys = true
        }
    }
    
    func updateHeroEmitter() {
        if hero.emit && hero.emitFrameCount < hero.maxEmitFrameCount {
            hero.emitFrameCount++
            hero.particles.hidden = false
        } else {
            hero.emit = false
            hero.particles.hidden = true
            hero.emitFrameCount = 0
        }
    }
    
    func updateScore() {
        score++
        if score % 4 != 0 {
            updated = false
        }
        scoreLabel.text = String(score)
    }
}
