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
  let bulletSpeed = CGFloat(80)
  
  var isThrusting = false
  
  init(shipNode: SKSpriteNode = SKSpriteNode(imageNamed: "ship"), thrustNode: SKSpriteNode = SKSpriteNode(imageNamed: "ship_thrust")) {
    self.shipNode = shipNode
    self.thrustNode = thrustNode
    
    super.init()
   
    setThrustPosition()
    self.addChild(self.shipNode)
    self.addChild(self.thrustNode)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func fire() {
    let bearing = getBearing()
    let bullet = SKSpriteNode(imageNamed:"shot")
    
    bullet.xScale = 2
    bullet.yScale = 2
    bullet.name = "bulletNode"
    
    let x = shipNode.position.x + CGFloat(bearing.x) * shipNode.size.width/2.0
    let y = shipNode.position.y + CGFloat(bearing.y) * shipNode.size.width/2.0
    bullet.position = CGPointMake(x, y)
    
    let action = SKAction.moveByX(CGFloat(bearing.x) * bulletSpeed, y: CGFloat(bearing.y) * bulletSpeed, duration: 1)
    bullet.runAction(SKAction.repeatActionForever(action))
    
    self.addChild(bullet)
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
}
