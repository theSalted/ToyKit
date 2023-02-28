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
    @Published var selectedScaleMode : SKSceneScaleMode = .resizeFill
    @Published var scaleModes : [SKSceneScaleMode] = [.resizeFill, .aspectFit, .aspectFill, .fill]
    
    @Published var selectedPhysicsBodyType : PhysicsBodyType = .staticPhysicsBody
    let physicsBodyType : [PhysicsBodyType] = [.dynamicPhysicsBody, .staticPhysicsBody, .none]
    
    @Published var isPaused = false
    
    lazy var avaliableComponent : [GKComponent] = {
        let backgroundColorSchemeSceneComponent = BackgroundColorSchemeSceneComponent(scene: scene)
        let physicsBodySceneComponentModel = PhysicsBodySceneComponentModel(scene: scene)
        let frictionSceneComponentModel = FrictionSceneComponentModel()
        let gravitySceneComponentModel = GravitySceneComponentModel(scene: scene)
        let emojiNodeSpawnerComponet = EmojiNodeSpawnerComponet()
        
        return [backgroundColorSchemeSceneComponent, physicsBodySceneComponentModel, frictionSceneComponentModel, gravitySceneComponentModel, emojiNodeSpawnerComponet]
    }()
    
    ///  Init game scene; expected to be called when SpriteView onAppear.
    func initGameScene() {
        updateSceneSizeSetting()
        updateAnchorPoint()
        addComponent(component: BackgroundColorSchemeSceneComponent(scene: scene))
        addComponent(component: PhysicsBodySceneComponentModel(scene: scene))
        addComponent(component: FrictionSceneComponentModel())
        addComponent(component: GravitySceneComponentModel(scene: scene))
        addComponent(component: EmojiNodeSpawnerComponet())
    }
    
    /// Ad component to `SceneSetting` and `GameScene`'s componets list
    func addComponent(component: GKComponent) {
        withAnimation {
            scene.sceneEntity.addComponent(component)
            self.objectWillChange.send()
        }
    }
    
    /// Remove component from `SceneSetting` and `GameScene`'s componets list
    func removeComponent(component: GKComponent) {
        withAnimation {
            scene.sceneEntity.removeComponent(ofType: component.componentType)
            self.objectWillChange.send()
        }
    }
    
    func logComponent() {
        print(scene.sceneEntity.components)
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
    
    /// update scene's anchor point
    @discardableResult func updateAnchorPoint() -> Bool {
        let numberRange = 0.0...1.0
        if(numberRange.contains(anchorPointX) && numberRange.contains(anchorPointY)) {
            scene.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
            scene.sceneEntity[PhysicsBodySceneComponentModel.self]?.updatePhysicsBodySetting()
            return true
        }
        anchorPointX = scene.anchorPoint.x
        anchorPointY = scene.anchorPoint.y
        return false
    }
}
