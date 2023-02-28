//
//  GravitySceneComponentModel.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/26/23.
//

import GameplayKit
import SpriteKit
import SwiftUI

/// Add this component to control gravity setting at the scene
@MainActor
final class GravitySceneComponentModel: GKComponent, ObservableObject {
    private var scene : SKScene
    @Published var gravityX : Double = 0.0
    @Published var gravityY : Double = -9.8
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
    
    override func didAddToEntity() {
        updateGravity()
    }
    
    override func willRemoveFromEntity() {
        setGravity(gravity: CGVector(dx: 0, dy: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Update the graivity of the scene with the settings
    func updateGravity() {
        scene.physicsWorld.gravity = CGVector(dx: gravityX,
                                              dy: gravityY)
    }
    
    /// Set the graivity of the scene
    func setGravity(gravity: CGVector) {
        self.gravityX = gravity.dx
        self.gravityY = gravity.dy
        updateGravity()
    }
    
    /// Display a configure view for this component
    @ViewBuilder
    func inspectorView() -> some View {
        GravityInspectorView(component: self)
    }
}
