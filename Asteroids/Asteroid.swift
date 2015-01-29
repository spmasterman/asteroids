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
  let maxSpeed: UInt32 = 60
  let minSpeed: UInt32 = 30
  
  init(size: AsteroidSize, position: CGPoint) {
    switch size {
    case AsteroidSize.Large:
      asteroidNode = SKSpriteNode(imageNamed: "asteroid_large_1")
    case AsteroidSize.Medium:
      asteroidNode = SKSpriteNode(imageNamed: "asteroid_med_1")
    case AsteroidSize.Small:
      asteroidNode = SKSpriteNode(imageNamed: "asteroid_small_1")
    }
    
    super.init()
    
    name = "asteroid";
    
    physicsBody = SKPhysicsBody(circleOfRadius: asteroidNode.size.width/2)
    physicsBody?.categoryBitMask = asteroidCategory
    physicsBody?.dynamic = true
    physicsBody?.linearDamping = 0
    physicsBody?.contactTestBitMask = shipCategory | bulletCategory;
    physicsBody?.collisionBitMask = 0;
    
    self.position = position
    
    let spin = getRandomAngle() - Float(M_PI)
    physicsBody?.angularVelocity = CGFloat(spin)
    
    let theta = getRandomAngle()
    let speed = arc4random_uniform(maxSpeed - minSpeed) + minSpeed

    let bearing = Vector2(Scalar(speed), 0).rotatedBy(theta)
    physicsBody?.velocity = CGVectorMake(CGFloat(bearing.x), CGFloat(bearing.y))
    
    self.addChild(asteroidNode)
  }
  
  func onImpactFromBullet() {
    self.removeFromParent()
  }
  
  func getRandomAngle()->Float {
    return Float(arc4random_uniform(UInt32.max))/Float(UInt32.max) * Float(M_PI) * 2.0
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