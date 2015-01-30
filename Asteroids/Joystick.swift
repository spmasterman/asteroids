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
  let backdropNode, thumbNode: SKSpriteNode
  let thumbSpringBackDuration: Double =  0.3
  var isTracking: Bool = false
  var valueVector = Vector2.Zero // vector of thumb position - max length unit vector

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
      
      let delta = Vector2(Scalar(touchPoint.x - thumbNode.position.x), Scalar(touchPoint.y - thumbNode.position.y))
      
      if self.isTracking == true && delta.length < Float(thumbNode.size.width) {
        let vectorToBoundary = Vector2(Scalar(touchPoint.x - anchorPointInPoints().x), Scalar(touchPoint.y - anchorPointInPoints().y))
        if vectorToBoundary.length <= Float(thumbNode.size.width) {
          thumbNode.position = CGPointMake(anchorPointInPoints().x + CGFloat(vectorToBoundary.x), anchorPointInPoints().y + CGFloat(vectorToBoundary.y))
        } else {
          let magnitude = vectorToBoundary.length
          
          let posX = Scalar(anchorPointInPoints().x) + vectorToBoundary.x / magnitude * Scalar(thumbNode.size.width)
          let posY = Scalar(anchorPointInPoints().y) + vectorToBoundary.y / magnitude * Scalar(thumbNode.size.height)
          thumbNode.position = CGPointMake(CGFloat(posX), CGFloat(posY))
        }
      }
      valueVector = Vector2(Scalar(thumbNode.position.x / thumbNode.size.width), Scalar(thumbNode.position.y / thumbNode.size.height))
   }
  }
  
  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    returnToCenter()
  }
  
  override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
    returnToCenter()
  }
  
  func returnToCenter() {
    isTracking = false
    valueVector = Vector2.Zero
    var centerAction: SKAction = SKAction.moveTo(self.anchorPointInPoints(), duration: thumbSpringBackDuration)
    centerAction.timingMode = SKActionTimingMode.EaseOut
    thumbNode.runAction(centerAction)
  }
}