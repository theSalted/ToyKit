//
//  SceneSettingsModel.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SwiftUI
import SpriteKit
import GameplayKit

/// An object that serve as a bridge between GameScene and GUI, shared between GameEditoView and its child views
@MainActor final class SceneSetting : ObservableObject {
    
    @Published var scene = GameScene()
    
    @Published var sceneSizeX : Double = 1000
    @Published var sceneSizeY : Double = 1000
    
    @Published var viewSizeX : Double = 1000
    @Published var viewSizeY : Double = 1000
    
    @Published var anchorPointX = 0.5
    @Published var anchorPointY = 0.0
    
    @Published var isDyniamicSceneSize = true
    @Published var isDynamicPhysicsBodyRendered = false
    
    @Published var selectedScaleMode : SKSceneScaleMode = .resizeFill
    @Published var scaleModes : [SKSceneScaleMode] = [.resizeFill, .aspectFit, .aspectFill, .fill]
    
    @Published var components = [GKComponent]()
    
    @Published var selectedPhysicsBodyType : PhysicsBodyType = .staticPhysicsBody
    let physicsBodyType : [PhysicsBodyType] = [.dynamicPhysicsBody, .staticPhysicsBody, .none]
    
    @Published var isPaused = false
    
    /// get render width of dynamic render bdoy
    var dynamicRenderBodyLineWidth: CGFloat {
        return scene.dynamicPhysicsBody.lineWidth
    }
    
    var testPause : Bool {
        scene.isPaused
    }
    
    ///  Init game scene; expected to be called when SpriteView onAppear.
    func initGameScene() {
        updateSceneSizeSetting()
        updateSKColorScheme()
        updateAnchorPoint()
        updatePhysicsBodySetting()
        addComponent(component: EmojiNodeSpawnerComponet())
    }
    
    // TODO: Deprecate the update functions and prevent views from assigning variables
    
    /// Update spritekit's color scheme based on light/dark mode
    func updateSKColorScheme() {
        // TODO: Expand color scheme to support custom background color
        #if canImport(AppKit)
        scene.backgroundColor = NSColor.windowBackgroundColor
        #elseif canImport(UIKit)
        scene.backgroundColor = UIColor.systemBackground
        #endif
    }
    
    /// Add component to `SceneSetting` and `GameScene`'s componets list
    func addComponent(component: GKComponent) {
        components.append(component)
        scene.sceneEntity.addComponent(component)
    }
    
    // TODO: find a better solution for pause state update
    /// Update game scene's pause state with a property
    func updatePauseWith(shouldPause : Bool) {
        isPaused = shouldPause
        updatePause()
    }
    
    /// Update game scene's pause state.
    func updatePause() {
        scene.isPaused = isPaused
    }
    
    /// Update wether to render dynamic physics body.
    @discardableResult func updateDynamicPhysicsBodyRender() -> Bool {
        if isDynamicPhysicsBodyRendered {
            scene.dynamicPhysicsBody.lineWidth = 3
            return true
        } else {
            scene.dynamicPhysicsBody.lineWidth = 0
            return false
        }
    }
    
    /// Update game scene's size and scale mode
    func updateSceneSizeSetting() {
        
        switch selectedScaleMode {
        case.resizeFill:
            isDyniamicSceneSize = true
        default:
            isDyniamicSceneSize = false
        }
        
        scene.scaleMode = selectedScaleMode
        
        if isDyniamicSceneSize {
            sceneSizeX = viewSizeX
            sceneSizeY = viewSizeY
        }
        
        scene.size = CGSize(width: sceneSizeX, height: sceneSizeY)
    }
    
    
    /// Update game physics body selection.
    func updatePhysicsBodySetting() {
        scene.physicsBodyType = selectedPhysicsBodyType
        
        switch scene.physicsBodyType {
        case .dynamicPhysicsBody:
            destroyAllPhysicsBody()
            initDynamicPhysicsBody()
        case .staticPhysicsBody:
            destroyAllPhysicsBody()
            initStaticPhysicsBody()
        case .none:
            scene.physicsBody = nil
            scene.dynamicPhysicsBody.removeFromParent()
        }
    }
    
    /// Update game physics body and settings with type.
    func updatePhysicsBody(type: PhysicsBodyType) {
        selectedPhysicsBodyType = type
        updatePhysicsBodySetting()
    }
    
    /// Add a physics body to scene.
    /// - Warning: Avoid direct call, call `updatePhysicsBody` instead
    func initStaticPhysicsBody()
    {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    }
    
    /// Add a dynamic physics body node to game scene.
    /// - Warning: Avoid direct call, call `updatePhysicsBody` instead
    func initDynamicPhysicsBody() {
        scene.dynamicPhysicsBody = scene.createDynamicPhysicsBody(nodeFrame: scene.frame)
        scene.addChild(scene.dynamicPhysicsBody)
        updateDynamicPhysicsBodyRender()
    }
    
    /// Destroy static physics body from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    func destroyStaticPhysicsBody()
    {
        scene.physicsBody = nil
    }
    
    /// Destroy dynamic physics body from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    func destroyDynamicPhysicsBody()
    {
        scene.dynamicPhysicsBody.removeFromParent()
    }
    
    /// Destroy all physics bodies from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    func destroyAllPhysicsBody()
    {
        destroyStaticPhysicsBody()
        destroyDynamicPhysicsBody()
    }
     
    /// update scene's anchor point
    @discardableResult func updateAnchorPoint() -> Bool {
        let numberRange = 0.0...1.0
        if(numberRange.contains(anchorPointX) && numberRange.contains(anchorPointY)) {
            scene.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
            updatePhysicsBodySetting()
            return true
        }
        anchorPointX = scene.anchorPoint.x
        anchorPointY = scene.anchorPoint.y
        return false
    }
}

class PhysicsBody :  GKComponent {
    var scene : GameScene {
        return GameScene()
    }
    
    var selectedPhysicsBodyType : PhysicsBodyType = .staticPhysicsBody
    var isDynamicPhysicsBodyRendered = false
    
    /// Update wether to render dynamic physics body.
    @discardableResult func updateDynamicPhysicsBodyRender() -> Bool {
        if isDynamicPhysicsBodyRendered {
            scene.dynamicPhysicsBody.lineWidth = 3
            return true
        } else {
            scene.dynamicPhysicsBody.lineWidth = 0
            return false
        }
    }
    
    /// Update game physics body selection.
    func updatePhysicsBodySetting() {
        scene.physicsBodyType = selectedPhysicsBodyType
        
        switch scene.physicsBodyType {
        case .dynamicPhysicsBody:
            destroyAllPhysicsBody()
            initDynamicPhysicsBody()
        case .staticPhysicsBody:
            destroyAllPhysicsBody()
            initStaticPhysicsBody()
        case .none:
            scene.physicsBody = nil
            scene.dynamicPhysicsBody.removeFromParent()
        }
    }
    
    /// Update game physics body and settings with type.
    func updatePhysicsBody(type: PhysicsBodyType) {
        selectedPhysicsBodyType = type
        updatePhysicsBodySetting()
    }
    
    /// Add a physics body to scene.
    /// - Warning: Avoid direct call, call `updatePhysicsBody` instead
    func initStaticPhysicsBody()
    {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    }
    
    /// Add a dynamic physics body node to game scene.
    /// - Warning: Avoid direct call, call `updatePhysicsBody` instead
    func initDynamicPhysicsBody() {
        scene.dynamicPhysicsBody = scene.createDynamicPhysicsBody(nodeFrame: scene.frame)
        scene.addChild(scene.dynamicPhysicsBody)
        updateDynamicPhysicsBodyRender()
    }
    
    /// Destroy static physics body from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    func destroyStaticPhysicsBody()
    {
        scene.physicsBody = nil
    }
    
    /// Destroy dynamic physics body from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    func destroyDynamicPhysicsBody()
    {
        scene.dynamicPhysicsBody.removeFromParent()
    }
    
    /// Destroy all physics bodies from game scene.
    /// - Warning: Avoid direct call, to remove physicsbody call `updatePhysicsBody(type: .none)` instead
    func destroyAllPhysicsBody()
    {
        destroyStaticPhysicsBody()
        destroyDynamicPhysicsBody()
    }
}
