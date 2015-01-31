//
//  DebrisField.swift
//  Asteroids
//
//  Created by Shaun Masterman on 30/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//


import SpriteKit

class DebrisField : SKNode {
  
  let maxLife: UInt32 = 4
  let minLife: UInt32 = 2
  let maxDistance: UInt32 = 90
  let minDistance: UInt32 = 15
  
  
  init(position: CGPoint, velocity: CGVector, count: Int8) {
  
    super.init()
    
    for _ in 1 ... count {
      var debrisNode = SKSpriteNode(imageNamed: "shot")
      debrisNode.xScale = 0.5
      debrisNode.yScale = 0.5

      addChild(debrisNode)
      
      let bearing = Vector2.X.rotatedBy(getRandomAngle()) * Scalar(arc4random_uniform(maxDistance - minDistance) + minDistance)
      let destination = CGPoint(x: CGFloat(bearing.x), y: CGFloat(bearing.y))
      let lifetime = NSTimeInterval(arc4random_uniform(maxLife - minLife) + minLife)
      let moveAction = SKAction.moveTo(destination, duration: lifetime)
      let cleanUpAction = SKAction.removeFromParent()
      debrisNode.runAction(SKAction.sequence([moveAction, cleanUpAction]))
    }
  
    name = "debrisField";
    
    self.position = position
    
    let lifetime = NSTimeInterval(maxLife)
    let moveAction = SKAction.moveBy(velocity, duration: lifetime)
    let cleanUpAction = SKAction.removeFromParent()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getRandomAngle()->Float {
    return Float(arc4random_uniform(UInt32.max))/Float(UInt32.max) * Float(M_PI) * 2.0
  }
}