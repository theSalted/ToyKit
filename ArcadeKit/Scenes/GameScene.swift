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
    
    // TODO: Deprecate these to comply to ECS
    var dynamicPhysicsBody = SKShapeNode()
    var physicsBodyType : PhysicsBodyType = .dynamicPhysicsBody
    
    private var isOngoingDPBReset = false
    
    override func didMove(to view: SKView) {
        //initDynamicPhysicsBody()
    }
    
    override func sceneDidLoad() {
        // declard and add entity to scene
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    override func didChangeSize(_ oldSize: CGSize) {
        
        // TODO: Achieve physicsBodyType swap in an ECS System
        if physicsBodyType == .dynamicPhysicsBody {
            resizeDynamicPhysicsBody(size: CGSize(width: frame.width, height: frame.height))
        }
        
        if physicsBodyType == .staticPhysicsBody {
            physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        }
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
    
    func addSceneEntity( ){
        
    }
    
    // TODO: Adopt touch input to an ECS system
    /// Tells this object that primary input has occured depending on platform. Left click on macOS, first touch on iOS and iPadOS
    func primaryInputDown(location: CGPoint)
    {
        if let emojiNode = self.sceneEntity[EmojiNodeSpawnerComponet.self]?.createRandomEmojiNode(position: location) {
            addChild(emojiNode)
        }
    }
    
    /// Create a SKShapeNode with physics boundaries as dynamic physics body
    func createDynamicPhysicsBody(nodeFrame : CGRect) -> SKShapeNode {
        var node = SKShapeNode(rect: nodeFrame)
        #if canImport(UIKit)
        node.strokeColor = UIColor(.blue)
        #elseif canImport(AppKit)
        node.strokeColor = NSColor(.blue)
        #endif
        node.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        return node
    }
    
    // Remove current dynamic physics body node then create a new node with same size and line width
    func resetDynamicPhysicsBody() {
        let dPLineWidth = dynamicPhysicsBody.lineWidth
        dynamicPhysicsBody.removeFromParent()
        dynamicPhysicsBody = createDynamicPhysicsBody(nodeFrame: frame)
        addChild(dynamicPhysicsBody)
        dynamicPhysicsBody.lineWidth = dPLineWidth
    }
    
    /// Resize dynamic physics boy's size
    func resizeDynamicPhysicsBody(size: CGSize) {
        if(!isOngoingDPBReset) {
            dynamicPhysicsBody.removeAllActions()
            var scaleFactorX = CGFloat()
            var scaleFactorY = CGFloat()
            
            var durationX = TimeInterval()
            var durationY = TimeInterval()
            
            scaleFactorX = frame.width / (dynamicPhysicsBody.frame.width / dynamicPhysicsBody.xScale)
            scaleFactorY = frame.height / (dynamicPhysicsBody.frame.height / dynamicPhysicsBody.yScale)
            
            if scaleFactorX > 1 {
                durationX = 0
            } else {
                durationX = (scaleFactorX/1) * 1
                if durationX < 0.2 {
                    durationX = 0.2
                }
            }
            
            if scaleFactorY > 1 {
                durationY = 0
            } else {
                durationY = (scaleFactorY/1) * 1
                if durationY < 0.2 {
                    durationY = 0.2
                }
            }
            
            let scaleX = SKAction.scaleX(to: scaleFactorX, duration: durationX)
            let scaleY = SKAction.scaleY(to: scaleFactorY, duration: durationY)
            let scale = SKAction.group([scaleX, scaleY])
            let reset = SKAction.run {
                self.resetDynamicPhysicsBody()
            }
            let sequence = SKAction.sequence([scale, reset])
            
            dynamicPhysicsBody.run(sequence)
        }
        
    }
}

















