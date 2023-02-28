//
//  PhysicsBodyComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/25/23.
//

import GameplayKit
import SceneKit
import SwiftUI

/// Add Physics Body to game scene, and add a view component to inspector that allows modifications to the scenes.
@MainActor final class PhysicsBodySceneComponentModel :  GKComponent, ObservableObject {
    @Published var physicsBodyType : PhysicsBodyType = .staticPhysicsBody
    @Published var isDynamicPhysicsBodyRendered = false
    
    private var scene : SKScene
    private var dynamicPhysicsBody = SKShapeNode()
    
    var physicsBody : SKPhysicsBody? {
        get {
            switch physicsBodyType {
            case .none:
                return nil
            case .dynamicPhysicsBody:
                return dynamicPhysicsBody.physicsBody
            case .staticPhysicsBody:
                return scene.physicsBody
            }
        }
    }
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     
    override func didAddToEntity() {
        // init physics body base on `physicsBodyType`
        updatePhysicsBodySetting()
    }
    
    override func willRemoveFromEntity() {
        // destroy all physics bodies on scene when component is remvoed
        destroyAllPhysicsBody()
    }
    
    /// Displayed as a side bar component view
    @ViewBuilder
    func inspectorView() -> some View {
        PhysicBodyInspectorView(component: self)
    }
    
    /// Create a SKShapeNode with physics boundaries as dynamic physics body
    private func createDynamicPhysicsBody(nodeFrame : CGRect) -> SKShapeNode {
        var node = SKShapeNode(rect: nodeFrame)
        #if canImport(UIKit)
        node.strokeColor = UIColor(.blue)
        #elseif canImport(AppKit)
        node.strokeColor = NSColor(.blue)
        #endif
        node.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
        return node
    }
    
    /// Add a physics body to scene.
    /// - Warning: Avoid direct call, call `updatePhysicsBody` instead
    private func initStaticPhysicsBody()
    {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    }
    
    /// Add a dynamic physics body node to game scene.
    /// - Warning: Avoid direct call, call `updatePhysicsBody` instead
    private func initDynamicPhysicsBody() {
        dynamicPhysicsBody = createDynamicPhysicsBody(nodeFrame: scene.frame)
        scene.addChild(dynamicPhysicsBody)
        updateDynamicPhysicsBodyRender()
    }
    
    /// Destroy static physics body from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    private func destroyStaticPhysicsBody()
    {
        scene.physicsBody = nil
    }
    
    /// Destroy dynamic physics body from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    private func destroyDynamicPhysicsBody()
    {
        dynamicPhysicsBody.removeFromParent()
    }
    
    /// Destroy all physics bodies from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    private func destroyAllPhysicsBody()
    {
        destroyStaticPhysicsBody()
        destroyDynamicPhysicsBody()
    }
    
    /// Resize dynamic physics boy's size
    private func resizeDynamicPhysicsBody(size: CGSize) {
        dynamicPhysicsBody.removeAllActions()
        var scaleFactorX = CGFloat()
        var scaleFactorY = CGFloat()
        
        scaleFactorX = size.width / (dynamicPhysicsBody.frame.width / dynamicPhysicsBody.xScale)
        scaleFactorY = size.height / (dynamicPhysicsBody.frame.height / dynamicPhysicsBody.yScale)
        
        let scaleX = SKAction.scaleX(to: scaleFactorX,
                                     duration: calculateDuration(scaleFactor: scaleFactorX))
        let scaleY = SKAction.scaleY(to: scaleFactorY,
                                     duration: calculateDuration(scaleFactor: scaleFactorY))
        let scale = SKAction.group([scaleX, scaleY])
        let reset = SKAction.run {
            self.updatePhysicsBodySetting()
        }
        let sequence = SKAction.sequence([scale, reset])
        
        dynamicPhysicsBody.run(sequence)
    }
    
    /// Calculate dyanmic physicsbody scale action dutation with scale factor
    private func calculateDuration(scaleFactor: CGFloat) -> TimeInterval {
        var duration = TimeInterval()
        
        if scaleFactor > 1 {
            duration = 0
        } else {
            duration = (scaleFactor/1) * 1
            if duration < 0.2 {
                duration = 0.2
            }
        }
        
        return duration
    }
    
    /// Update game physics body to reflect settings.
    /// - Note: Use `updatePhysicsBody` to update with type
    func updatePhysicsBodySetting() {
        switch physicsBodyType {
        case .dynamicPhysicsBody:
            destroyAllPhysicsBody()
            initDynamicPhysicsBody()
        case .staticPhysicsBody:
            destroyAllPhysicsBody()
            initStaticPhysicsBody()
        case .none:
            destroyAllPhysicsBody()
        }
        
        // update firction setting if `FrictionSceneComponentModel` is installed
        coComponent(ofType: FrictionSceneComponentModel.self)?.updateFriction()
    }
    
    /// Update game physics body and settings with type.
    func updatePhysicsBody(type: PhysicsBodyType) {
        physicsBodyType = type
        updatePhysicsBodySetting()
    }
    
    /// Update wether to render dynamic physics body.
    func updateDynamicPhysicsBodyRender() {
        if isDynamicPhysicsBodyRendered {
            dynamicPhysicsBody.lineWidth = 3
        } else {
            dynamicPhysicsBody.lineWidth = 0
        }
    }
    
    // TODO: Restrain access level to `Internal` once modualized
    /// Update physics body when scene size changed
    /// - Warning: Do not call directly
    func sceneChangeSize() {
        switch physicsBodyType {
        case .dynamicPhysicsBody:
            resizeDynamicPhysicsBody(size: CGSize(width: scene.frame.width, height: scene.frame.height))
        default:
            updatePhysicsBodySetting()
        }
    }
}
