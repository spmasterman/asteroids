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
    var joystick = Joystick(thumbNode: SKSpriteNode(imageNamed: "thumb_stick"), backdropNode:SKSpriteNode(imageNamed: "dpad"))
   var fireButton = SKSpriteNode(imageNamed: "fire")
   var thrustButton = SKSpriteNode(imageNamed: "thrust")
  
    override func didMoveToView(view: SKView) {
      backgroundColor = SKColor.blackColor()
      ship.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
      addChild(ship)
    
      joystick.position = CGPointMake(CGFloat(100), CGFloat(100))
      addChild(joystick)
      
      fireButton.position = CGPointMake(CGFloat(size.width - 100), CGFloat(100))
      thrustButton.position = CGPointMake(CGFloat(size.width - 170), CGFloat(100))
      addChild(fireButton)
      addChild(thrustButton)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"asteroid_large_1")
            
            sprite.xScale = 1
            sprite.yScale = 1
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI / 3), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
  
    override func update(currentTime: CFTimeInterval) {
      if joystick.velocity.x != 0 || joystick.velocity.y != 0 {
        ship.zRotation = joystick.angularVelocity + CGFloat(M_PI_2)
      }
    }
}
