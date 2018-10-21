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
        let debrisNode = SKSpriteNode(imageNamed: "shot")
      debrisNode.xScale = 0.5
      debrisNode.yScale = 0.5

      addChild(debrisNode)
      
        let bearing = Vector2.X.rotatedBy(radians: getRandomAngle()) * Scalar(arc4random_uniform(maxDistance - minDistance) + minDistance)
      let destination = CGPoint(x: CGFloat(bearing.x), y: CGFloat(bearing.y))
      let lifetime = TimeInterval(arc4random_uniform(maxLife - minLife) + minLife)
        let moveAction = SKAction.move(to: destination, duration: lifetime)
      let cleanUpAction = SKAction.removeFromParent()
        debrisNode.run(SKAction.sequence([moveAction, cleanUpAction]))
    }
  
    name = "debrisField";
    
    self.position = position
    
    let lifetime = TimeInterval(maxLife)
    _ = SKAction.move(by: velocity, duration: lifetime)
    _ = SKAction.removeFromParent()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func getRandomAngle()->Float {
    return Float(arc4random_uniform(UInt32.max))/Float(UInt32.max) * .pi * 2.0
  }
}
