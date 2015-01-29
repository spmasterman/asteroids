//
//  Ship.swift
//  Asteroids
//
//  Created by Shaun Masterman on 28/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import Foundation
import SpriteKit

class Ship : SKNode {
  let shipNode, thrustNode: SKSpriteNode
  let thrusterPower = Scalar(6.0)
  
  var isThrusting = false
  var isDead = false
  var isInvincible = false
  
  init(shipNode: SKSpriteNode = SKSpriteNode(imageNamed: "ship"), thrustNode: SKSpriteNode = SKSpriteNode(imageNamed: "ship_thrust")) {
    self.shipNode = shipNode
    self.thrustNode = thrustNode
    
    super.init()
    
    physicsBody = SKPhysicsBody(rectangleOfSize: shipNode.size)
    physicsBody?.categoryBitMask = shipCategory
    physicsBody?.dynamic = true
    physicsBody?.contactTestBitMask = asteroidCategory;
    physicsBody?.collisionBitMask = 0;
    name = "ship";
    
    setThrustPosition()
    self.addChild(self.shipNode)
    self.addChild(self.thrustNode)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func onImpact() {
    if isDead || isInvincible {
      return
    }
    
    isDead = true
    hidden = true
  }
  
  func fire() {
    if !isDead {
      let bearing = getBearing()
      
      let x = position.x + CGFloat(bearing.x) * shipNode.size.width/2.0
      let y = position.y + CGFloat(bearing.y) * shipNode.size.width/2.0
      
      let bullet = Bullet(position: CGPointMake(x, y), bearing: bearing, velocity:physicsBody?.velocity)
      self.scene?.addChild(bullet)
    }
  }
  
  func thrust() {
    let bearing = getBearing() * thrusterPower
    physicsBody?.applyForce(CGVectorMake(CGFloat(bearing.x), CGFloat(bearing.y)) )
  }
  
  func setThrustPosition() {
    thrustNode.zRotation = shipNode.zRotation
    thrustNode.hidden = !isThrusting
    
    let bearing = getBearing()
    let x = shipNode.position.x - CGFloat(bearing.x) * shipNode.size.width/2.0
    let y = shipNode.position.y - CGFloat(bearing.y) * shipNode.size.width/2.0
    thrustNode.position = CGPointMake(x, y)
  }
  
  func getBearing() -> Vector2 {
    return Vector2(Scalar(shipNode.size.width) / 2.0, 0).rotatedBy(Scalar(shipNode.zRotation)).normalized()
  }
  
  func setHeading(zRotation: CGFloat) {
    shipNode.zRotation = zRotation
  }
  
  func update(currentTime: CFTimeInterval) {
    setThrustPosition()
    if (isThrusting) {
      thrust()
    }
    
    let xPadding = shipNode.size.width/4
    let yPadding = shipNode.size.height/4
    
    if (position.x < -xPadding) {
      position.x = scene!.size.width + xPadding
    } else if (position.x > (scene!.size.width + xPadding)) {
      position.x = -xPadding
    }
    
    if (position.y < -yPadding) {
      position.y = scene!.size.height + yPadding
    } else if(position.y > (scene!.size.height + yPadding)) {
      position.y = -yPadding
    }
  }
}
