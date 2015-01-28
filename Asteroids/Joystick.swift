//
//  Joystick.swift
//  Asteroids
//
//  Created by Shaun Masterman on 26/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import Foundation
import SpriteKit

class Joystick : SKNode {
  let kThumbSpringBackDuration: Double =  0.3
  let backdropNode, thumbNode: SKSpriteNode
  var isTracking: Bool = false
  var velocity: CGPoint = CGPointMake(0, 0)
  var travelLimit: CGPoint = CGPointMake(0, 0)
  var angularVelocity: CGFloat = 0.0
  var size: Float = 0.0
  
  func anchorPointInPoints() -> CGPoint {
    return CGPointMake(0, 0)
  }
  
  init(thumbNode: SKSpriteNode = SKSpriteNode(imageNamed: "thumb_stick"), backdropNode: SKSpriteNode = SKSpriteNode(imageNamed: "dpad")) {
    self.thumbNode = thumbNode
    self.backdropNode = backdropNode
    
    super.init()
    
    self.addChild(self.backdropNode)
    self.addChild(self.thumbNode)
    
    self.userInteractionEnabled = true
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    for touch in touches {
      var touchPoint: CGPoint = touch.locationInNode(self)
      if self.isTracking == false && CGRectContainsPoint(self.thumbNode.frame, touchPoint) {
        self.isTracking = true
      }
    }
  }
  
  override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    for touch in touches {
      var touchPoint: CGPoint = touch.locationInNode(self)
      
      if self.isTracking == true && sqrtf(powf((Float(touchPoint.x) - Float(self.thumbNode.position.x)), 2) + powf((Float(touchPoint.y) - Float(self.thumbNode.position.y)), 2)) < Float(self.thumbNode.size.width) {
        if sqrtf(powf((Float(touchPoint.x) - Float(self.anchorPointInPoints().x)), 2) + powf((Float(touchPoint.y) - Float(self.anchorPointInPoints().y)), 2)) <= Float(self.thumbNode.size.width) {
          var moveDifference: CGPoint = CGPointMake(touchPoint.x - self.anchorPointInPoints().x, touchPoint.y - self.anchorPointInPoints().y)
          self.thumbNode.position = CGPointMake(self.anchorPointInPoints().x + moveDifference.x, self.anchorPointInPoints().y + moveDifference.y)
        } else {
          var vX: Double = Double(touchPoint.x) - Double(self.anchorPointInPoints().x)
          var vY: Double = Double(touchPoint.y) - Double(self.anchorPointInPoints().y)
          var magV: Double = sqrt(vX*vX + vY*vY)
          var aX: Double = Double(self.anchorPointInPoints().x) + vX / magV * Double(self.thumbNode.size.width)
          var aY: Double = Double(self.anchorPointInPoints().y) + vY / magV * Double(self.thumbNode.size.width)
          self.thumbNode.position = CGPointMake(CGFloat(aX), CGFloat(aY))
        }
      }
      self.velocity = CGPointMake(((self.thumbNode.position.x - self.anchorPointInPoints().x)), ((self.thumbNode.position.y - self.anchorPointInPoints().y)))
      self.angularVelocity = -atan2(self.thumbNode.position.x - self.anchorPointInPoints().x, self.thumbNode.position.y - self.anchorPointInPoints().y)
    }
  }
  
  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    self.resetVelocity()
  }
  
  override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
    self.resetVelocity()
  }
  
  func resetVelocity() {
    self.isTracking = false
    self.velocity = CGPointZero
    var easeOut: SKAction = SKAction.moveTo(self.anchorPointInPoints(), duration: kThumbSpringBackDuration)
    easeOut.timingMode = SKActionTimingMode.EaseOut
    self.thumbNode.runAction(easeOut)
  }
}