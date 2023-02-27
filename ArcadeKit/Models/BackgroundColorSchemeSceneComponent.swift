//
//  BackgroundColorSchemeSceneComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/26/23.
//

import GameplayKit
import SpriteKit

/// Make scene support darkmode
class BackgroundColorSchemeSceneComponent : GKComponent {
    
    private var scene : SKScene
    
    init(scene: SKScene) {
        self.scene = scene
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        updateSKColorScheme()
    }
    
    /// Update spritekit's color scheme based on light/dark mode
    func updateSKColorScheme() {
        // TODO: Expand color scheme to support custom background color
        #if canImport(AppKit)
        scene.backgroundColor = NSColor.windowBackgroundColor
        #elseif canImport(UIKit)
        scene.backgroundColor = UIColor.systemBackground
        #endif
    }
}
