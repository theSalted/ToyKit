//
//  AnchorPointSceneComponentModel.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import GameplayKit
import SpriteKit
import SwiftUI

@MainActor
final class AnchorPointSceneComponentModel : GKComponent, ObservableObject, InspectorView {
    private var scene: SKScene
    
    var isRemoveable = false
    var isPriority = true
    
    @Published var anchorPointX = 0.5
    @Published var anchorPointY = 0.0
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        updateAnchorPoint()
    }
    
    override func willRemoveFromEntity() {
        setAnchorPoint(point: CGPoint(x: 0.0, y: 0.0))
    }
    
    /// Update scene's anchor point
    func updateAnchorPoint() {
        let numberRange = 0.0...1.0
        if(numberRange.contains(anchorPointX) && numberRange.contains(anchorPointY)) {
            scene.anchorPoint = CGPoint(x: anchorPointX, y: anchorPointY)
            coComponent(ofType: PhysicsBodySceneComponentModel.self)?.updatePhysicsBodySetting()
        }
        anchorPointX = scene.anchorPoint.x
        anchorPointY = scene.anchorPoint.y
    }
    
    /// Set scene's anchor point
    func setAnchorPoint(point: CGPoint) {
        anchorPointX = point.x
        anchorPointY = point.y
        updateAnchorPoint()
    }
    
    /// Display a configure view for this component
    @ViewBuilder
    func inspectorView() -> some View {
        AnchorPointInspectorView(component: self)
    }
}
