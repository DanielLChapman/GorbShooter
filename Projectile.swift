//
//  Particle.swift
//  PointShoot
//
//  Created by Daniel Chapman on 11/11/14.
//  Copyright (c) 2014 Daniel Chapman. All rights reserved.
//

import Foundation

import SpriteKit

class Particle {
    var speed:Float = 0.4
    var guy: SKSpriteNode
    var currentFrame = 0
    var randomFrame = 0
    var moving = false
    var angle = 0.0
    var range = 2.0
    var yPos = CGFloat()
    var xPos = CGFloat()
    var targetX = CGFloat()
    var targetY = CGFloat()
    
    init(speed:Float,guy:SKSpriteNode,targetX:CGFloat,targetY:CGFloat) {
        self.speed = speed
        self.guy = guy
        self.setRandomFrame()
        self.targetX = targetX
        self.targetY = targetY
    }
    
    func setRandomFrame() {
        var range = UInt32(50)..<UInt32(200)
        self.randomFrame = Int(range.startIndex + arc4random_uniform(range.endIndex-range.startIndex+1))
    }
    
    func fire() {
        let moveAction = SKAction.moveTo(CGPointMake(targetX, targetY), duration: NSTimeInterval(speed) + 0.3 )
        moveAction.timingMode = SKActionTimingMode.EaseOut
        self.guy.runAction(moveAction, completion: {self.guy.hidden = true; self.guy.removeFromParent()})
    }
    
}