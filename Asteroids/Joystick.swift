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
    return CGPoint(x: 0, y: 0)
  }
  
  init(thumbNode: SKSpriteNode = SKSpriteNode(imageNamed: "thumb_stick"), backdropNode: SKSpriteNode = SKSpriteNode(imageNamed: "dpad")) {
    self.thumbNode = thumbNode
    self.backdropNode = backdropNode
    
    super.init()
    
    self.addChild(self.backdropNode)
    self.addChild(self.thumbNode)
    self.isUserInteractionEnabled = true
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
        let touchPoint: CGPoint = touch.location(in: self)
        if self.isTracking == false && self.thumbNode.frame.contains(touchPoint) {
        self.isTracking = true
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
      let touchPoint: CGPoint = touch.location(in: self)
      
      let delta = Vector2(Scalar(touchPoint.x - thumbNode.position.x), Scalar(touchPoint.y - thumbNode.position.y))
      
      if self.isTracking == true && delta.length < Float(thumbNode.size.width) {
        let vectorToBoundary = Vector2(Scalar(touchPoint.x - anchorPointInPoints().x), Scalar(touchPoint.y - anchorPointInPoints().y))
        if vectorToBoundary.length <= Float(thumbNode.size.width) {
            thumbNode.position = CGPoint(x: anchorPointInPoints().x + CGFloat(vectorToBoundary.x), y: anchorPointInPoints().y + CGFloat(vectorToBoundary.y))
        } else {
          let magnitude = vectorToBoundary.length
          
          let posX = Scalar(anchorPointInPoints().x) + vectorToBoundary.x / magnitude * Scalar(thumbNode.size.width)
          let posY = Scalar(anchorPointInPoints().y) + vectorToBoundary.y / magnitude * Scalar(thumbNode.size.height)
            thumbNode.position = CGPoint(x: CGFloat(posX), y: CGFloat(posY))
        }
      }
      valueVector = Vector2(Scalar(thumbNode.position.x / thumbNode.size.width), Scalar(thumbNode.position.y / thumbNode.size.height))
   }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    returnToCenter()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    returnToCenter()
  }
  
  func returnToCenter() {
    isTracking = false
    valueVector = Vector2.Zero
    let centerAction: SKAction = SKAction.move(to: self.anchorPointInPoints(), duration: thumbSpringBackDuration)
    centerAction.timingMode = SKActionTimingMode.easeOut
    thumbNode.run(centerAction)
  }
}
