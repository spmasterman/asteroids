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
  let shipNode, thrustNode, shieldNode: SKSpriteNode
  let thrusterPower = Scalar(6.0)
  
  var isThrusting = false
  var isDead = false
  var isInvincible = false
  
  let deadPause = CFTimeInterval(3)
  let invinciblePause = CFTimeInterval(3)
  
  var deadTime: CFTimeInterval = 0 //cumulative time we've been dead
  var invincibleTime: CFTimeInterval = 0 // cumulative time we've been invincible
  
  init(shipNode: SKSpriteNode = SKSpriteNode(imageNamed: "ship"),
       thrustNode: SKSpriteNode = SKSpriteNode(imageNamed: "ship_thrust"),
       shieldNode: SKSpriteNode = SKSpriteNode(imageNamed: "shield")) {
    
    self.shipNode = shipNode
    self.thrustNode = thrustNode
    self.shieldNode = shieldNode
    
    self.thrustNode.isHidden = true
    self.shieldNode.isHidden = true
    
    super.init()
    
    physicsBody = SKPhysicsBody(polygonFrom: getPath())
    physicsBody?.categoryBitMask = shipCategory
    physicsBody?.isDynamic = true
    physicsBody?.contactTestBitMask = asteroidCategory
    physicsBody?.collisionBitMask = 0
    physicsBody?.allowsRotation = true
    physicsBody?.angularDamping = 5000.0
    physicsBody?.usesPreciseCollisionDetection = true
    
    name = "ship";
    
    setSubViewPositions()
    self.addChild(self.thrustNode)
    self.addChild(self.shieldNode)
    self.addChild(self.shipNode)
  }
  
  func getPath()->CGPath {
    var points = [CGPoint]()
    points.append(CGPoint(x: 0.6 * shipNode.size.width/2.0 - 3, y: 0.0))
    points.append(CGPoint(x: 0.8 * -shipNode.size.width/2.0 - 2, y: 0.6 * shipNode.size.height/2.0))
    points.append(CGPoint(x: 0.8 * -shipNode.size.width/2.0 - 2, y: 0.6 * -shipNode.size.height/2.0))
    
    let path = CGMutablePath()
    let cpg = points[0]
    path.move(to: cpg)
    for p in points {
        path.addLine(to: p)
    }
    path.closeSubpath()
    return path
  }
  
  func getDebrisStartPositions()->[Int: debrisPosition]{
    let theta = CGFloat(Double.pi/2 / 3)
   
    var positions = [Int: debrisPosition]()
    
    positions[1] = (position: CGPoint(x: shipNode.size.width/4, y: shipNode.size.height/8), zRotation: -theta)
    positions[2] = (position: CGPoint(x: shipNode.size.width/4, y: -shipNode.size.height/8), zRotation: theta)
    positions[3] = (position: CGPoint(x: -shipNode.size.width/4, y: 3 * shipNode.size.height/8), zRotation: -theta)
    positions[4] = (position: CGPoint(x: -shipNode.size.width/4, y: -3 * shipNode.size.height/8), zRotation: theta)
    positions[5] = (position: CGPoint(x: -3 * shipNode.size.width/4, y: shipNode.size.height/2), zRotation: -2 * theta)
    positions[6] = (position: CGPoint(x: -3 * shipNode.size.width/4, y: -shipNode.size.height/2), zRotation: 2 * theta)
    
    return positions
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func onImpact() {
    if isDead || isInvincible {
      return
    }
    
    (scene as! GameScene).looseLife()
    isDead = true
    isHidden = true
  }
  
  func fire() {
    if !isDead {
      let bearing = getBearing()
      
      let x = position.x + CGFloat(bearing.x) * shipNode.size.width/2.0
      let y = position.y + CGFloat(bearing.y) * shipNode.size.width/2.0
      
        let bullet = Bullet(position: CGPoint(x: x, y: y), bearing: bearing, velocity:physicsBody?.velocity)
      self.scene?.addChild(bullet)
    }
  }
  
  func thrust() {
    let bearing = getBearing() * thrusterPower
    physicsBody?.applyForce(CGVector(dx: CGFloat(bearing.x), dy: CGFloat(bearing.y)) )
  }
  
  func setSubViewPositions() {
    shipNode.position = CGPoint(x: -6.0, y: 0.0)
    
    thrustNode.zRotation = shipNode.zRotation
    thrustNode.position = CGPoint(x: -6.0 - shipNode.size.width/2.0, y: 0.0)
    
    shieldNode.zRotation = shipNode.zRotation
    shieldNode.position = CGPoint(x: -5.0, y: 0.0)
  }
  
  func getBearing() -> Vector2 {
    return Vector2.X.rotatedBy(radians: Scalar(zRotation)).normalized()
  }
  
  func steer(joysticInput: Vector2) {
    physicsBody?.applyAngularImpulse(CGFloat(getBearing().angleWith(v: joysticInput) / 30))
  }
  
  func update(currentTime: CFTimeInterval) {
    thrustNode.isHidden = !isThrusting
    shieldNode.isHidden = !isInvincible
    
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
  
    if (isDead) {
      if (deadTime == 0) {
        deadTime = currentTime
      } else if (currentTime - deadTime > deadPause) {
          deadTime = 0;
          invincibleTime = 0
          isDead = false
          isInvincible = true
          position = (scene as! GameScene).getSpawnPosition()
          physicsBody?.velocity = CGVector(dx:0, dy:0)
          zRotation = 0
        isHidden = false
      }
    }
    
    if (isInvincible) {
      if (invincibleTime == 0) {
        invincibleTime = currentTime
      } else if (currentTime - invincibleTime > invinciblePause) {
        invincibleTime = 0
        isInvincible = false
     }
    }
  }
}
