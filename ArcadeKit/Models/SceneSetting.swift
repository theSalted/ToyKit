//
//  SceneSettingsModel.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SwiftUI
import SpriteKit
import GameplayKit
import OctopusKit

/// An object that serve as a bridge between GameScene and GUI, shared between GameEditoView and its child views
@MainActor final class SceneSetting : ObservableObject {
    
    @Published var scene = GameScene()
    
    @Published var isPaused = false
    
    // TODO: Maybe turn this into an enum? Pro/Con
    lazy var avaliableComponents : [GKComponent] = {
        let viewSettingSceneComponentModel = ViewSettingSceneComponentModel(scene: scene)
        let anchorPointSceneComponentModel = AnchorPointSceneComponentModel(scene: scene)
        let backgroundColorSchemeSceneComponent = BackgroundColorSchemeSceneComponent(scene: scene)
        let physicsBodySceneComponentModel = PhysicsBodySceneComponentModel(scene: scene)
        let frictionSceneComponentModel = FrictionSceneComponentModel()
        let gravitySceneComponentModel = GravitySceneComponentModel(scene: scene)
        let pointerEventComponent = PointerEventComponent(node: scene)
        
        let emojiNodeSpawnerComponet = EmojiNodeSpawnerComponet(node: scene)
        
        #if canImport(AppKit)
        let mouseEventComponent = MouseEventComponent()
        
        return [viewSettingSceneComponentModel, anchorPointSceneComponentModel, backgroundColorSchemeSceneComponent, physicsBodySceneComponentModel, frictionSceneComponentModel, gravitySceneComponentModel, mouseEventComponent, pointerEventComponent, emojiNodeSpawnerComponet]
        
        #elseif canImport(UIKit)
        let touchEventComponent = TouchEventComponent()
        
        return [viewSettingSceneComponentModel, anchorPointSceneComponentModel, backgroundColorSchemeSceneComponent, physicsBodySceneComponentModel, frictionSceneComponentModel, gravitySceneComponentModel, touchEventComponent, pointerEventComponent, emojiNodeSpawnerComponet]
        
        #endif
    }()
    
    ///  Init game scene; expected to be called when SpriteView onAppear.
    func initGameScene() {
        addComponent(component: ViewSettingSceneComponentModel(scene: scene))
        addComponent(component: AnchorPointSceneComponentModel(scene: scene))
        addComponent(component: BackgroundColorSchemeSceneComponent(scene: scene))
        addComponent(component: PhysicsBodySceneComponentModel(scene: scene))
        addComponent(component: FrictionSceneComponentModel())
        addComponent(component: GravitySceneComponentModel(scene: scene))
        addComponent(component: EmojiNodeSpawnerComponet(node: scene))
    }
    
    /// Add component to `GameScene`'s componets list
    func addComponent(component: GKComponent) {
        withAnimation {
            checkPackageComponent(component: component)
            scene.sceneEntity.addComponent(component)
            self.objectWillChange.send()
        }
    }
    
    // Check if a component is a package, if so add all dependent to scene
    private func checkPackageComponent(component: GKComponent) {
        if let packageComponet = component as? PackageComponent {
            for dependentComponent in packageComponet.dependentComponents {
                for avaliableComponent in avaliableComponents {
                    if dependentComponent == avaliableComponent.componentType {
                        addComponent(component: avaliableComponent)
                    }
                }
            }
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
}
