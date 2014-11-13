//
//  BadGuy.swift
//  SwiftKitSkip
//
//  Created by Daniel Chapman on 11/11/14.
//  Copyright (c) 2014 Daniel Chapman. All rights reserved.
//

import Foundation

import SpriteKit

class BadGuy {
    var speed:Float = 0.0
    var guy: SKSpriteNode
    var currentFrame = 0
    var randomFrame = 0
    var moving = false
    var angle = 0.0
    var range = 2.0
    var yPos = CGFloat()
    
    init(speed:Float,guy:SKSpriteNode) {
        self.speed = speed
        self.guy = guy
        self.setRandomFrame()
    }
    
    func setRandomFrame() {
        var range = UInt32(50)..<UInt32(200)
        self.randomFrame = Int(range.startIndex + arc4random_uniform(range.endIndex-range.startIndex+1))
    }
    
    func fire() {
        let moveAction = SKAction.moveTo(CGPointMake(CGFloat(0), CGFloat(0)), duration: NSTimeInterval(speed) + 2.3 )
        moveAction.timingMode = SKActionTimingMode.EaseOut
        self.guy.runAction(moveAction, completion: {self.guy.hidden = true; self.guy.removeFromParent()})
    }
    
}