//
//  Saucer.swift
//  Asteroids
//
//  Created by Shaun Masterman on 22/10/2018.
//  Copyright © 2018 Southbase Limited. All rights reserved.
//

import SpriteKit

class Saucer : SKNode {
    
    let maxSpeed: UInt32 = 80
    let minSpeed: UInt32 = 50
    
    var saucerNode: SKSpriteNode
    
    init(saucerNode: SKSpriteNode = SKSpriteNode(imageNamed: "saucer"), position: CGPoint) {
 
        self.saucerNode = saucerNode
        
        super.init()
        
        physicsBody = SKPhysicsBody(circleOfRadius: 4.0)
        physicsBody?.categoryBitMask = saucerCategory
        physicsBody?.isDynamic = true
        physicsBody?.contactTestBitMask = shipCategory | bulletCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.allowsRotation = false
        physicsBody?.usesPreciseCollisionDetection = true
        
        name = "saucer";
        
        self.position = position
   
        let theta = getRandomAngle()
        let speed = arc4random_uniform(maxSpeed - minSpeed) + minSpeed
        
        let bearing = Vector2(Scalar(speed), 0).rotatedBy(radians: theta)
        physicsBody?.velocity = CGVector(dx: CGFloat(bearing.x), dy: CGFloat(bearing.y))
        
        self.addChild(self.saucerNode)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
