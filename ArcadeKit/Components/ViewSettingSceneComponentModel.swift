//
//  ViewSettingSceneComponentModel.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/27/23.
//

import GameplayKit
import SpriteKit
import SwiftUI


@MainActor
final class ViewSettingSceneComponentModel : GKComponent, ObservableObject, InspectorView {
    
    var isRemoveable = false
    var isPriority = true
    
    private var scene: SKScene
    
    @Published var sceneSizeX : Double = 1000
    @Published var sceneSizeY : Double = 1000
    
    @Published var viewSizeX : Double = 1000
    @Published var viewSizeY : Double = 1000
    
    @Published var isDyniamicSceneSize = true
    @Published var selectedScaleMode : SKSceneScaleMode = .resizeFill
    @Published var scaleModes : [SKSceneScaleMode] = [.resizeFill, .aspectFit, .aspectFill, .fill]
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        updateViewSizeSetting()
    }
    
    /// Update game scene's size and scale mode
    func updateViewSizeSetting() {
        
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
    
    /// Set game scene's size and scale mode
    /// - NOTE: Setting viewSize and .resizeFill can cause view stretch improperly
    func setSceneSizeSetting(size : CGPoint, scaleMode: SKSceneScaleMode) {
        sceneSizeX = size.x
        sceneSizeY = size.y
        selectedScaleMode = scaleMode
        updateViewSizeSetting()
    }
    
    func setViewSize(size : CGSize) {
        viewSizeX = size.width
        viewSizeY = size.height
    }
    
    @ViewBuilder
    func inspectorView() -> some View {
        ViewSettingInspectorView(component: self)
    }
}
