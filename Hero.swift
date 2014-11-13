//
//  Hero.swift
//  SwiftKitSkip
//
//  Created by Daniel Chapman on 11/11/14.
//  Copyright (c) 2014 Daniel Chapman. All rights reserved.
//

import Foundation

import SpriteKit

class Hero {
    var guy:SKSpriteNode
    var speed = 0.1
    var emit = false
    var emitFrameCount = 0
    var maxEmitFrameCount = 30
    var particles:SKEmitterNode
    
    init(guy:SKSpriteNode, particles:SKEmitterNode) {
        self.guy = guy
        self.particles = particles
    }
}