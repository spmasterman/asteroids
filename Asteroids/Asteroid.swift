//
//  Asteroid.swift
//  Asteroids
//
//  Created by Shaun Masterman on 29/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import SpriteKit

enum AsteroidSize {
  case Large
  case Medium
  case Small
}

class Asteroid : SKNode {

  var asteroidNode: SKSpriteNode
  var aSize: AsteroidSize
  let maxSpeed: UInt32 = 60
  let minSpeed: UInt32 = 30
  
  init(size: AsteroidSize, position: CGPoint) {
    var physicsBodyContraction: CGFloat = 1.0
    switch size {
    case AsteroidSize.Large:
      asteroidNode = SKSpriteNode(imageNamed: "asteroid_large_1")
      physicsBodyContraction = 0.8
    case AsteroidSize.Medium:
      asteroidNode = SKSpriteNode(imageNamed: "asteroid_med_1")
      physicsBodyContraction = 0.7
    case AsteroidSize.Small:
      asteroidNode = SKSpriteNode(imageNamed: "asteroid_small_1")
      physicsBodyContraction = 0.5
    }
    aSize = size
    
    super.init()
    
    name = "asteroid"
    
    physicsBody = SKPhysicsBody(circleOfRadius: physicsBodyContraction * CGFloat(asteroidNode.size.width/2))
    physicsBody?.categoryBitMask = asteroidCategory
    physicsBody?.isDynamic = true
    physicsBody?.linearDamping = 0
    physicsBody?.contactTestBitMask = shipCategory | bulletCategory
    physicsBody?.collisionBitMask = 0
    physicsBody?.angularDamping = 0
    physicsBody?.usesPreciseCollisionDetection = true
    
    self.position = position
    
    let spin = getRandomAngle() - .pi
    physicsBody?.angularVelocity = CGFloat(spin)
    
    let theta = getRandomAngle()
    let speed = arc4random_uniform(maxSpeed - minSpeed) + minSpeed

    let bearing = Vector2(Scalar(speed), 0).rotatedBy(radians: theta)
    physicsBody?.velocity = CGVector(dx: CGFloat(bearing.x), dy: CGFloat(bearing.y))
    
    self.addChild(asteroidNode)
  }
  
  func onImpactFromBullet(bulletPosition: CGPoint?) {
    var nextSize: AsteroidSize?
    
    switch aSize {
    case AsteroidSize.Large:
      nextSize = AsteroidSize.Medium
    case AsteroidSize.Medium:
      nextSize = AsteroidSize.Small
    case AsteroidSize.Small:
      nextSize = nil
    }
    
    if (nextSize != nil) {
      for _ in 1...3 {
        let pendingAsteroid = (nextSize!, position)
        (scene! as! GameScene).pendingAsteroids.append(pendingAsteroid)
      }
    }
  
    if bulletPosition != nil && physicsBody?.velocity != nil {
      let pendingDebrisField: (position: CGPoint, velocity: CGVector, count: Int8) = (position: bulletPosition!, velocity: physicsBody!.velocity, count: 10)
      (scene! as! GameScene).pendingDebrisFields.append(pendingDebrisField)
    }
    self.removeFromParent()
  }
  
  func getRandomAngle()->Float {
    return Float(arc4random_uniform(UInt32.max))/Float(UInt32.max) * .pi * 2.0
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func update(currentTime: CFTimeInterval) {
    let xPadding = asteroidNode.size.width/4
    let yPadding = asteroidNode.size.height/4
    
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
