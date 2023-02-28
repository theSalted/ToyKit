//
//  GameScene.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SpriteKit
import SwiftUI
import GameplayKit

/// An object that organize all of the active game contents.
final class GameScene : SKScene {
    /// Child `GKEntity` relevant to gameplay
    /// - Use `addEntity()` and `removeEntity()` to add and remove individual entity
    var entities = Set<GKEntity>()
    
    /// An entity relevant to gameplay associate with game scene object
    var sceneEntity = GKEntity()
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        sceneEntity[PhysicsBodySceneComponentModel.self]?.sceneChangeSize()
    }
    
    #if canImport(UIKit)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        primaryInputDown(location: location)
    }
    #elseif canImport(AppKit)
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        primaryInputDown(location: location)
    }
    #endif
    
    /// Add an entity and its node to end of the reciver's enities list
    func addEntity(_ entity: GKEntity) {
        entities.insert(entity)
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            scene?.addChild(spriteNode)
        }
    }
    
    /// Add an entity and its node from its parent
    func removeEntity(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
    }
    
    // TODO: Adopt touch input to an ECS system
    /// Tells this object that primary input has occured depending on platform. Left click on macOS, first touch on iOS and iPadOS
    func primaryInputDown(location: CGPoint)
    {
        if let emojiNode = self.sceneEntity[EmojiNodeSpawnerComponet.self]?.createRandomEmojiNode(position: location) {
            addChild(emojiNode)
        }
    }
}

