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

  var pendingAsteroids: [(AsteroidSize, CGPoint)] = []
  var pendingDebrisFields: [(position: CGPoint, velocity: CGVector, count: Int8)] = []
  var pendingShipDebrisFields: [(position: CGPoint, velocity: CGVector)] = []
  
  var lives = 0;
  var startLives = 3;
  
  func didBeginContact(contact: SKPhysicsContact!) {
    var firstBody: SKPhysicsBody!
    var secondBody: SKPhysicsBody!
    
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    if (firstBody.categoryBitMask & bulletCategory) != 0 &&
      (secondBody.categoryBitMask & asteroidCategory) != 0 {
      if (firstBody.node != nil) {  // bullet can hit two things at once - second one should be ignored as bullet will be removed already
        (secondBody.node as Asteroid).onImpactFromBullet((firstBody.node as Bullet).position)
        (firstBody.node as Bullet).onImpact()
      }
    }
    
    if (firstBody.categoryBitMask & shipCategory) != 0 &&
      (secondBody.categoryBitMask & asteroidCategory) != 0 {
        (firstBody.node as Ship).onImpact()
    }
  }
  
  func getSpawnPosition() -> CGPoint {
    return CGPoint(x: size.width * 0.1, y: size.height * 0.5)
  }
  
  override func didMoveToView(view: SKView) {
    backgroundColor = SKColor.blackColor()
    
    physicsWorld.gravity = CGVectorMake(0,0);
    physicsWorld.contactDelegate = self;
    
    ship.position = getSpawnPosition()
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
    
    spawnAsteroids(.Large, count: 3)
    
    for _ in 1...startLives {
      gainLife()
    }
  }
  
  func gainLife() {
    lives++
    var life = SKSpriteNode(imageNamed: "life")
    life.name = "life\(lives)"
    let y = size.height - life.size.height
    let x = CGFloat(size.width - 10) - (0.4  * CGFloat(lives) * CGFloat(life.size.width))
    life.position = CGPoint(x: x, y: y)
    addChild(life)
  }
  
  func looseLife() {
    if (ship.physicsBody != nil) {
      let pendingShipDebrisField: (position: CGPoint, velocity: CGVector) = (position: ship.position, velocity: ship.physicsBody!.velocity)
      pendingShipDebrisFields.append(pendingShipDebrisField)
    
      let pendingDebrisField: (position: CGPoint, velocity: CGVector, count: Int8) = (position: ship.position, velocity: ship.physicsBody!.velocity, count: 30)
      (scene! as GameScene).pendingDebrisFields.append(pendingDebrisField)
    }
    
    enumerateChildNodesWithName("life\(lives)", usingBlock:  {
      (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
        node.removeFromParent()
    })
    
    if lives-- == 0 {
      let reveal = SKTransition.flipHorizontalWithDuration(0.5)
      let gameOverScene = GameOverScene(size: self.size, won: false)
      self.view?.presentScene(gameOverScene, transition: reveal)
    }
  }
  
  func spawnAsteroids(asteroidSize: AsteroidSize, count: Int) {
    for _ in 1...count {
      addAsteroid(asteroidSize,  position: CGPoint(x: size.width - CGFloat(arc4random_uniform(UInt32(size.width * 0.5))), y: CGFloat(arc4random_uniform(UInt32(size.height)))))
    }
  }
  
  func addAsteroid(size: AsteroidSize, position: CGPoint) {
    addChild(Asteroid(size: size, position: position))
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
  
  override func update(currentTime: CFTimeInterval) {
    ship.steer(joystick.valueVector)
    ship.update(currentTime)
    
    removeOffscreenBullets()
    
    var anyAsteroidsLeft = false
    enumerateChildNodesWithName("asteroid", usingBlock:  {
      (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
      (node as Asteroid).update(currentTime)
      anyAsteroidsLeft = true
    })

    if (!anyAsteroidsLeft) {
      spawnAsteroids(.Large, count: 3)
    }
    
    for pendingAsteroid in pendingAsteroids {
      addAsteroid(pendingAsteroid.0, position: pendingAsteroid.1)
    }
    pendingAsteroids = []
  
    for pendingDebrisField in pendingDebrisFields {
        addChild(DebrisField(position: pendingDebrisField.position, velocity: pendingDebrisField.velocity, count: pendingDebrisField.count))
    }
    pendingDebrisFields = []
    
    for pendingShipDebrisField in pendingShipDebrisFields {
      addChild(ShipDebrisField(position: pendingShipDebrisField.position, velocity: pendingShipDebrisField.velocity, positions: ship.getDebrisStartPositions(), zRotation: ship.zRotation))
    }
    pendingShipDebrisFields = []
    
  }
}
