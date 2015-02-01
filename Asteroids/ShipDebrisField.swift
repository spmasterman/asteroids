//
//  DebrisField.swift
//  Asteroids
//
//  Created by Shaun Masterman on 30/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//


import SpriteKit

typealias debrisPosition = (position: CGPoint, zRotation: CGFloat)

class ShipDebrisField : SKNode {
  
  let maxLife: UInt32 = 3
  let minLife: UInt32 = 1
  let maxDistance: UInt32 = 45
  let minDistance: UInt32 = 5
  
  init(position: CGPoint, velocity: CGVector, positions:[Int: debrisPosition], zRotation: CGFloat) {
    
    super.init()

    self.zRotation = zRotation
   
    for index in 1 ... 6 {
      var debrisNode = SKSpriteNode(imageNamed: "ship_debris")
      debrisNode.xScale = 1
      debrisNode.yScale = 1
    
      let debrisInit = positions[index]
      debrisNode.position = debrisInit!.position
      debrisNode.zRotation = debrisInit!.zRotation
      
      addChild(debrisNode)
      
      let bearing = Vector2.X.rotatedBy(getRandomAngle()) * Scalar(arc4random_uniform(maxDistance - minDistance) + minDistance)
      let destination = CGPoint(x: CGFloat(bearing.x), y: CGFloat(bearing.y))
      let lifetime = NSTimeInterval(arc4random_uniform(maxLife - minLife) + minLife)
      
      let moveAction = SKAction.moveTo(destination, duration: lifetime)
      let fadeAction = SKAction.fadeOutWithDuration(lifetime)
      let rotateAction = SKAction.rotateByAngle(CGFloat(getRandomAngle()), duration: lifetime)
      let cleanUpAction = SKAction.removeFromParent()
      
      debrisNode.runAction(SKAction.sequence([SKAction.group([moveAction, fadeAction, rotateAction]), cleanUpAction]))
    }

    name = "shipDebrisField";
     
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