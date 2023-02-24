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
    @Published var viewEntity = GKEntity()
    
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
        if selectedPhysicsBodyType == .dynamicPhysicsBody {
            initDynamicPhysicsBody()
        } else {
            scene.dynamicPhysicsBody.removeFromParent()
        }
        
        if selectedPhysicsBodyType == .staticPhysicsBody {
            initPhysicsBody()
        } else {
            scene.physicsBody = nil
        }
        
    }
    
    /// Add a physics body to scene.
    func initPhysicsBody()
    {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    }
    
    /// Add a dynamic physics body node to game scene.
    func initDynamicPhysicsBody() {
        if selectedPhysicsBodyType == .dynamicPhysicsBody {
            scene.dynamicPhysicsBody.removeFromParent()
            scene.dynamicPhysicsBody = scene.createDynamicPhysicsBody(nodeFrame: scene.frame)
            scene.addChild(scene.dynamicPhysicsBody)
            updateDynamicPhysicsBodyRender()
        }
    }
    
    /// update scene's anchor point
    @discardableResult func updateAnchorPoint() -> Bool {
        let numberRange = 0.0...1.0
        if(numberRange.contains(anchorPointX) && numberRange.contains(anchorPointY)) {
            scene.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
            initDynamicPhysicsBody()
            return true
        }
        anchorPointX = scene.anchorPoint.x
        anchorPointY = scene.anchorPoint.y
        return false
    }
}
