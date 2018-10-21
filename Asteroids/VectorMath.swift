//
//  VectorMath.swift
//  Asteroids
//
//  Created by Shaun Masterman on 27/01/2015.
//  Copyright (c) 2015 Southbase Limited. All rights reserved.
//

import Foundation

typealias Scalar = Float

struct Vector2 {
  var x: Scalar
  var y: Scalar
}

//MARK: Scalar

extension Scalar {
  
  static let Pi = Scalar(Double.pi)
  static let HalfPi = Scalar(Double.pi/2)
  static let QuarterPi = Scalar(Double.pi/4)
  static let TwoPi = Scalar(Double.pi * 2)
  static let DegreesPerRadian = 180 / Pi
  static let RadiansPerDegree = Pi / 180
  static let Epsilon: Scalar = 0.0001
}

func ~=(lhs: Scalar, rhs: Scalar) -> Bool {
  return abs(lhs - rhs) < .Epsilon
}

//MARK: Vector2

extension Vector2: Equatable, Hashable {
  
  static let Zero = Vector2(0, 0)
  static let X = Vector2(1, 0)
  static let Y = Vector2(0, 1)
  
  var hashValue: Int {
    return x.hashValue &+ y.hashValue
  }
  
  var lengthSquared: Scalar {
    return x * x + y * y
  }
  
  var length: Scalar {
    return sqrt(lengthSquared)
  }
  
  var inverse: Vector2 {
    return -self
  }
  
  init(_ x: Scalar, _ y: Scalar) {
    self.init(x: x, y: y)
  }
  
  init(_ v: [Scalar]) {
    
    assert(v.count == 2, "array must contain 2 elements, contained \(v.count)")
    
    x = v[0]
    y = v[1]
  }
  
  func toArray() -> [Scalar] {
    return [x, y]
  }
  
  func dot(v: Vector2) -> Scalar {
    return x * v.x + y * v.y
  }
  
  func cross(v: Vector2) -> Scalar {
    return x * v.y - y * v.x
  }
  
  func normalized() -> Vector2 {
    
    let lengthSquared = self.lengthSquared
    if lengthSquared ~= 0 || lengthSquared ~= 1 {
      return self
    }
    return self / sqrt(lengthSquared)
  }
  
  func rotatedBy(radians: Scalar) -> Vector2 {
    
    let cs = cos(radians)
    let sn = sin(radians)
    return Vector2(x * cs - y * sn, x * sn + y * cs)
  }
  
  func rotatedBy(radians: Scalar, around pivot: Vector2) -> Vector2 {
    return (self - pivot).rotatedBy(radians: radians) + pivot
  }
  
  func angleWith(v: Vector2) -> Scalar {
    
    if self == v {
      return 0
    }
    
    let t1 = normalized()
    let t2 = v.normalized()
    let cross = t1.cross(v: t2)
    let dot = max(-1, min(1, t1.dot(v: t2)))
    
    return atan2(cross, dot)
  }
  
  func interpolatedWith(v: Vector2, t: Scalar) -> Vector2 {
    return self + (v - self) * t
  }
}

prefix func -(v: Vector2) -> Vector2 {
  return Vector2(-v.x, -v.y)
}

func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
  return Vector2(lhs.x + rhs.x, lhs.y + rhs.y)
}

func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
  return Vector2(lhs.x - rhs.x, lhs.y - rhs.y)
}

func *(lhs: Vector2, rhs: Vector2) -> Vector2 {
  return Vector2(lhs.x * rhs.x, lhs.y * rhs.y)
}

func *(lhs: Vector2, rhs: Scalar) -> Vector2 {
  return Vector2(lhs.x * rhs, lhs.y * rhs)
}

func /(lhs: Vector2, rhs: Vector2) -> Vector2 {
  return Vector2(lhs.x / rhs.x, lhs.y / rhs.y)
}

func /(lhs: Vector2, rhs: Scalar) -> Vector2 {
  return Vector2(lhs.x / rhs, lhs.y / rhs)
}

func ==(lhs: Vector2, rhs: Vector2) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

func ~=(lhs: Vector2, rhs: Vector2) -> Bool {
  return lhs.x ~= rhs.x && lhs.y ~= rhs.y
}
