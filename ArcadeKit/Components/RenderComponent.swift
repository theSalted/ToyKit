//
//  RenderComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/23/23.
//

import GameplayKit
import SpriteKit

/// An component that create a `RenderComponent` to represent an image or solid color
class RenderComponent: GKComponent {
    // MARK: Properties
    
    // The `RenderComponent` vends a node allowing an entity to be rendered in a scene
    private let node : SKNode
    
    override init() {
        node = SKNode()
        super.init()
    }
    
    init(node: SKNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Overrides
    override func didAddToEntity() {
        node.entity = entity
    }
    
    override func willRemoveFromEntity() {
        node.entity = nil
    }
}
