//
//  GameScene.swift
//  Asteroids
//
//  Created by Shaun Masterman on 26/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  var ship = SKSpriteNode(imageNamed: "ship")
  var thrust = SKSpriteNode(imageNamed: "ship_thrust")
  var joystick = Joystick(thumbNode: SKSpriteNode(imageNamed: "thumb_stick"), backdropNode:SKSpriteNode(imageNamed: "dpad"))
  var fireButton = SKSpriteNode(imageNamed: "fire")
  var thrustButton = SKSpriteNode(imageNamed: "thrust")
  var isThrusting = false
  
  override func didMoveToView(view: SKView) {
    backgroundColor = SKColor.blackColor()
    ship.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    addChild(ship)
    setThrustPosition()
    
    addChild(thrust)
    joystick.position = CGPointMake(CGFloat(100), CGFloat(100))
    addChild(joystick)
    
    fireButton.position = CGPointMake(CGFloat(size.width - 100), CGFloat(100))
    fireButton.zPosition = 1.0
    fireButton.name = "fireButtonNode"
    thrustButton.position = CGPointMake(CGFloat(size.width - 170), CGFloat(100))
    thrustButton.zPosition = 1.0
    thrustButton.name = "thrustButtonNode"
    
    addChild(fireButton)
    addChild(thrustButton)
  }
  
  func setThrustPosition() {
    thrust.zRotation = ship.zRotation
    thrust.hidden = !isThrusting
    let bearing = getShipBearing()
    
    let x = ship.position.x - CGFloat(bearing.x) * ship.size.width/2.0
    let y = ship.position.y - CGFloat(bearing.y) * ship.size.width/2.0
    thrust.position = CGPointMake(x, y)

  }
  
  func getShipBearing() -> Vector2
  {
     return Vector2(Scalar(ship.size.width) / 2.0, 0).rotatedBy(Scalar(ship.zRotation)).normalized()
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    for touch: AnyObject in touches {
      let location = touch.locationInNode(self)
      let bearing = getShipBearing()
      
      var node = nodeAtPoint(location)
      
      if (node.name == "fireButtonNode") {
        let bullet = SKSpriteNode(imageNamed:"shot")
        bullet.xScale = 2
        bullet.yScale = 2
        bullet.name = "bulletNode"

        let x = ship.position.x + CGFloat(bearing.x) * ship.size.width/2.0
        let y = ship.position.y + CGFloat(bearing.y) * ship.size.width/2.0
        bullet.position = CGPointMake(x, y)

        let bulletSpeed = CGFloat(30.0)
        let action = SKAction.moveByX(CGFloat(bearing.x) * bulletSpeed, y: CGFloat(bearing.y) * bulletSpeed, duration: 1)
        bullet.runAction(SKAction.repeatActionForever(action))
        self.addChild(bullet)
      }
      
      if (node.name == "thrustButtonNode") {
        isThrusting = true
      }
    }
  }
  
  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    for touch: AnyObject in touches {
      let location = touch.locationInNode(self)
      var node = nodeAtPoint(location)
      if (node.name == "thrustButtonNode") {
        isThrusting = false
      }
    }
  }
  
  override func update(currentTime: CFTimeInterval) {
    if joystick.velocity.x != 0 || joystick.velocity.y != 0 {
      ship.zRotation = joystick.angularVelocity + CGFloat(M_PI_2)
    }
    setThrustPosition()
    
    // remove bullets that leave screen
    self.enumerateChildNodesWithName("bulletNode", usingBlock:  {
      (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
      
      if (node.position.x < 0 || node.position.x > self.size.width || node.position.y < 0 || node.position.y > self.size.height) {
        node.removeFromParent()
        println("removed!")
      }
      
    })
    
  }
}
