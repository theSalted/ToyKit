//
//  SceneSettingsModel.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SwiftUI
import SpriteKit


@MainActor final class SceneSettingsModel : ObservableObject {
    
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
    
    @Published var selectedPhysicsBodyType : PhysicsBodyType = .staticPhysicsBody
    let physicsBodyType : [PhysicsBodyType] = [.dynamicPhysicsBody, .staticPhysicsBody, .none]
    
    @Published var isPaused = false
    
    var dynamicRenderBodyLineWidth: CGFloat {
        return scene.dynamicPhysicsBody.lineWidth
    }
    
    func initGameScene() {
        updateSceenSizeSetting()
        updateSKColorScheme()
        updateAnchorPoint()
        updatePhysicsBodySetting()
    }
    
    func updateSKColorScheme() {
        #if canImport(AppKit)
        scene.backgroundColor = NSColor.windowBackgroundColor
        #endif
    }
    
    func updatePause() {
        scene.isPaused = isPaused
    }
    
    @discardableResult func updateDynamicPhysicsBodyRender() -> Bool {
        if isDynamicPhysicsBodyRendered {
            scene.dynamicPhysicsBody.lineWidth = 3
            return true
        } else {
            scene.dynamicPhysicsBody.lineWidth = 0
            return false
        }
    }
    
    func updateSceenSizeSetting() {
        
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
    
    func initPhysicsBody()
    {
        scene.physicsBody = SKPhysicsBody(edgeLoopFrom: scene.frame)
    }
    
    
    func updateSceneSizeWithGeometryProxy(_ geometry: GeometryProxy) -> some View {
        if isDyniamicSceneSize {
            DispatchQueue.main.async {
                self.sceneSizeX = geometry.size.width
                self.sceneSizeY = geometry.size.height
            }
        }
        
        return Spacer().frame(width: 0, height: 0).hidden()
    }
    
    func initDynamicPhysicsBody() {
        if selectedPhysicsBodyType == .dynamicPhysicsBody {
            scene.dynamicPhysicsBody.removeFromParent()
            scene.dynamicPhysicsBody = scene.createDynamicPhysicsBody()
            scene.addChild(scene.dynamicPhysicsBody)
            updateDynamicPhysicsBodyRender()
        }
    }
    
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
