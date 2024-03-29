//
//  GameScene.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/22/23.
//

import SpriteKit
import SwiftUI
import GameplayKit
import os

/// An object that organize all of the active game contents.
final class GameScene : SKScene {
    
    
    // MARK: Properties
    
    let logger = Logger(subsystem: "me.chenyuha.arcadekit", category: "Game Scene")
    
    /// An entity relevant to gameplay associate with game scene object
    var sceneEntity = GKEntity()
    
    // MARK: Overrides
    override func update(_ currentTime: TimeInterval) {
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        sceneEntity.component(ofType: PhysicsBodySceneComponentModel.self)?.sceneChangeSize()
        //sceneEntity[PhysicsBodySceneComponentModel.self]?.sceneChangeSize()
    }
    
    // MARK: Input Relays
    #if canImport(UIKit)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneEntity.component(ofType: TouchEventComponent.self)?.updateEvent(touches: touches, event: event, type: .touchesBegan)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneEntity.component(ofType: TouchEventComponent.self)?.updateEvent(touches: touches, event: event, type: .touchesEnded)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneEntity.component(ofType: TouchEventComponent.self)?.updateEvent(touches: touches, event: event, type: .touchesMoved)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneEntity.component(ofType: TouchEventComponent.self)?.updateEvent(touches: touches, event: event, type: .touchesCancelled)
    }
    
    #elseif canImport(AppKit)
    
    override func mouseUp(with event: NSEvent) {
        sceneEntity.component(ofType: MouseEventComponent.self)?.updateEvent(event: event, type: .mouseUp)
    }
    
    override func mouseDown(with event: NSEvent) {
        sceneEntity.component(ofType: MouseEventComponent.self)?.updateEvent(event: event, type: .mouseDown)
    }
    
    override func mouseMoved(with event: NSEvent) {
        sceneEntity.component(ofType: MouseEventComponent.self)?.updateEvent(event: event, type: .mouseMoved)
    }
    
    override func mouseEntered(with event: NSEvent) {
        sceneEntity.component(ofType: MouseEventComponent.self)?.updateEvent(event: event, type: .mouseEntered)
    }
    
    override func mouseExited(with event: NSEvent) {
        sceneEntity.component(ofType: MouseEventComponent.self)?.updateEvent(event: event, type: .mouseExited)
    }
    
    override func mouseDragged(with event: NSEvent) {
        sceneEntity.component(ofType: MouseEventComponent.self)?.updateEvent(event: event, type: .mouseDragged)
    }
    #endif
}

