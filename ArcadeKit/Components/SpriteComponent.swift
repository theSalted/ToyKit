//
//  SpriteComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/23/23.
//

import GameplayKit
import SpriteKit

/// An component that create a `SKSpriteNode` to represent an image or solid color
class SpriteComponent: GKComponent {

  let node: SKSpriteNode

  init(texture: SKTexture) {
    node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
