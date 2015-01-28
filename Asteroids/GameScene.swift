//
//  GameScene.swift
//  Asteroids
//
//  Created by Shaun Masterman on 26/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import SpriteKit

  class GameScene: SKScene {
  
  let ship = Ship()
  let joystick = Joystick()
  let fireButton = Button(buttonNode: SKSpriteNode(imageNamed: "fire"))
  let thrustButton = Button(buttonNode: SKSpriteNode(imageNamed: "thrust"))

  override func didMoveToView(view: SKView) {
    backgroundColor = SKColor.blackColor()
    
    ship.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    addChild(ship)
    
    joystick.position = CGPointMake(CGFloat(100), CGFloat(100))
    addChild(joystick)
    
    fireButton.position = CGPointMake(CGFloat(size.width - 100), CGFloat(100))
    fireButton.down = {
      self.ship.fire()
    }
    addChild(fireButton)
    
    thrustButton.position = CGPointMake(CGFloat(size.width - 170), CGFloat(100))
    thrustButton.down = {
      self.ship.isThrusting = true
    }
    thrustButton.up = {
      self.ship.isThrusting = false
    }
    addChild(thrustButton)
  }
  
  override func update(currentTime: CFTimeInterval) {
    if joystick.velocity.x != 0 || joystick.velocity.y != 0 {
       ship.setHeading(joystick.angularVelocity + CGFloat(M_PI_2))
    }
    ship.setThrustPosition()
    
    // remove bullets that leave screen
    self.enumerateChildNodesWithName("bulletNode", usingBlock:  {
      (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
      
      if (node.position.x < 0 || node.position.x > self.size.width || node.position.y < 0 || node.position.y > self.size.height) {
        node.removeFromParent()
      }
    })
  }
}
