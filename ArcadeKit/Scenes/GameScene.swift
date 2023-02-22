//
//  GameScene.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SpriteKit
import SwiftUI

/// An object that organize all of the active game contents.
final class GameScene : SKScene {
    
    var dynamicPhysicsBody = SKShapeNode()
    var physicsBodyType : PhysicsBodyType = .dynamicPhysicsBody
    
    private var isOngoingDPBReset = false
    
    override func didMove(to view: SKView) {
        //initDynamicPhysicsBody()
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
    
    // TODO: Adopt touch input to an ECS system
    /// Tells this object that primary input has occured depending on platform. Left click on macOS, first touch on iOS and iPadOS
    func primaryInputDown(location: CGPoint)
    {
        addChild(createRandomEmojiNode(position: location))
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
    
    // TODO: adopt to an ECS architecture
    /// Create an randon emoji  as SKLabelNode and offset it
    func createRandomEmojiNode(position: CGPoint) -> SKLabelNode {
        let emojis = "👾🕹🚀🎮📱⌚️💿📀🧲🧿🎲🍏🥎🍄🧠👁💩😈👿👻💀👽🤖🎃👊🏻💧☁️🚗💣🧸🧩🎨🎸⚽️🎱🍖🍑🍆🍩🍌⭐️🌈🌸🌺🌼🐹🦊🐼🐱🐶❤️🧡💛💚💙💜💔🔶🔷♦️"
        let randomEmoji = String(emojis.randomElement()!)
        let emojiNode = SKLabelNode(text: randomEmoji)
        emojiNode.fontSize = 64
        emojiNode.position = position
        emojiNode.zPosition = -10
        
        emojiNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(widthAndHeight: 50), center: CGPoint(x: 0, y: 20))
        
        let randomAdjustment = CGVector(dx: CGFloat(Int.random(in: -40...40)),
                                        dy: CGFloat(Int.random(in: -10...25)))
        
        let randomForce = CGVector(dx: randomAdjustment.dx/3,
                                   dy: CGFloat(Int.random(in: 15...25)))
        emojiNode.run(
            .sequence([
                .applyImpulse(randomForce, duration: 0.1),
                .wait(forDuration: 10.0),
                .fadeOut(withDuration: 0.5),
                .removeFromParent()
            ])
        )
        return emojiNode
    }
}

