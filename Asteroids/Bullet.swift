//
//  Bullet.swift
//  Asteroids
//
//  Created by Shaun Masterman on 28/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import SpriteKit

class Bullet : SKNode {

  let bulletNode: SKSpriteNode = SKSpriteNode(imageNamed: "shot")
  let bulletSpeed = CGFloat(80)
  
  init(position: CGPoint, bearing: Vector2, velocity: CGVector?) {
    super.init()
    
    bulletNode.xScale = 1
    bulletNode.yScale = 1
    name = "bullet";
    
    physicsBody = SKPhysicsBody(circleOfRadius: 2)
    physicsBody?.categoryBitMask = bulletCategory
    physicsBody?.isDynamic = true
    physicsBody?.linearDamping = 0
    physicsBody?.contactTestBitMask = asteroidCategory
    physicsBody?.collisionBitMask = 0
    physicsBody?.usesPreciseCollisionDetection = true
    
    self.position = position
    
    let x = (velocity?.dx ?? 0) + CGFloat(bearing.x) * bulletSpeed
    let y = (velocity?.dy ?? 0) + CGFloat(bearing.y) * bulletSpeed
    physicsBody?.velocity = CGVector(dx: x, dy: y)
    
    let spin = 0 - Double.pi
    physicsBody?.angularVelocity = CGFloat(spin)
    
    addChild(bulletNode)
  }
  
  func onImpact() {
    self.removeFromParent()
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
