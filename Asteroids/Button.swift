//
//  Button.swift
//  Asteroids
//
//  Created by Shaun Masterman on 28/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import SpriteKit

class Button: SKNode {

  var buttonNode: SKSpriteNode
  var onDown: () -> Void = {}
  var onUp: () -> Void = {}
  
  init(buttonNode: SKSpriteNode) {
    self.buttonNode = buttonNode
    self.buttonNode.zPosition = 1.0
    
    super.init()
    
    self.addChild(self.buttonNode)
    self.isUserInteractionEnabled = true
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for _ in touches {
      onDown()
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for _ in touches {
      onUp()
    }
  }
}
