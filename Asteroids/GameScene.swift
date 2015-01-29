//
//  GameScene.swift
//  Asteroids
//
//  Created by Shaun Masterman on 26/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import SpriteKit

let shipCategory: UInt32 =  0x1 << 0;
let bulletCategory: UInt32 =  0x1 << 1;
let asteroidCategory: UInt32 =  0x1 << 2;

class GameScene: SKScene, SKPhysicsContactDelegate {
  let ship = Ship()
  let joystick = Joystick()
  let fireButton = Button(buttonNode: SKSpriteNode(imageNamed: "fire"))
  let thrustButton = Button(buttonNode: SKSpriteNode(imageNamed: "thrust"))

  override func didMoveToView(view: SKView) {
    backgroundColor = SKColor.blackColor()
    
    physicsWorld.gravity = CGVectorMake(0,0);
    physicsWorld.contactDelegate = self;
    
    ship.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    addChild(ship)
    
    joystick.position = CGPointMake(CGFloat(100), CGFloat(100))
    addChild(joystick)
    
    fireButton.position = CGPointMake(CGFloat(size.width - 100), CGFloat(100))
    fireButton.onDown = { self.ship.fire() }
    addChild(fireButton)
    
    thrustButton.position = CGPointMake(CGFloat(size.width - 170), CGFloat(100))
    thrustButton.onDown = { self.ship.isThrusting = true }
    thrustButton.onUp = { self.ship.isThrusting = false }
    addChild(thrustButton)
    
    for index in 1...3 {
      let position = CGPoint(x: size.width - CGFloat(arc4random_uniform(UInt32(size.width * 0.5))), y: CGFloat(arc4random_uniform(UInt32(size.height))))
      let asteroid = Asteroid(size: .Large, position: position)
      addChild(asteroid)
    }
  }
  
  func removeOffscreenBullets() {
    enumerateChildNodesWithName("bullet", usingBlock:  {
      (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
      
      let x = node.position.x
      let y = node.position.y
      
      if (x < 0 || x > self.size.width || y < 0 || y > self.size.height) {
        node.removeFromParent()
      }
    })
  }
  
  func wrapAsteroids() {
      }
  
  override func update(currentTime: CFTimeInterval) {
    if joystick.velocity.x != 0 || joystick.velocity.y != 0 {
       ship.setHeading(joystick.angularVelocity + CGFloat(M_PI_2))
    }
    ship.update(currentTime)
    
    removeOffscreenBullets()
    
    enumerateChildNodesWithName("asteroid", usingBlock:  {
      (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
      (node as Asteroid).update(currentTime)
    })

  }
}
