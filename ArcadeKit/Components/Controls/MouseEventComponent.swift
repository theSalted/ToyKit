//
//  MouseEventComponent.swift
//  ArcadeKit
//
//  Created by Yuhao Chen on 2/28/23.
//

import GameplayKit

#if canImport(AppKit)
/// Attach this component to subscribe to scene's mouse events
@available(macOS 10, *)
final class MouseEventComponent : GKComponent {
    
    enum MouseEventType {
        case mouseUp, mouseDown, mouseMoved, mouseEntered, mouseExited, mouseDragged
    }
    
    lazy private var mouseUpCallbacks = [(NSEvent) -> Void]()
    lazy private var mouseDownCallbacks = [(NSEvent) -> Void]()
    lazy private var mouseMovedCallbacks = [(NSEvent) -> Void]()
    lazy private var mouseEnteredCallbacks = [(NSEvent) -> Void]()
    lazy private var mouseExitedCallbacks = [(NSEvent) -> Void]()
    lazy private var mouseDraggedCallbacks = [(NSEvent) -> Void]()
    
    /// Inform each item in callback list that useser has triggered a mouse event of designated type
    /// - Warning: This is a utility function exclusively for system defined `SKScene` object to update subscribers and should not be called by user
    func updateEvent(event: NSEvent, type: MouseEventType) {
        switch type {
        case .mouseUp:
            for mouseUpCallback in mouseUpCallbacks {
                mouseUpCallback(event)
            }
        case .mouseDown:
            for mouseDownCallback in mouseDownCallbacks {
                mouseDownCallback(event)
            }
        case .mouseMoved:
            for mouseMovedCallback in mouseMovedCallbacks {
                mouseMovedCallback(event)
            }
        case .mouseEntered:
            for mouseEnteredCallback in mouseEnteredCallbacks {
                mouseEnteredCallback(event)
            }
        case .mouseExited:
            for mouseExitedCallback in mouseExitedCallbacks {
                mouseExitedCallback(event)
            }
        case .mouseDragged:
            for mouseDraggedCallback in mouseDraggedCallbacks {
                mouseDraggedCallback(event)
            }
        }
    }
    
    /// Clear callbacks
    func clearCallbacks() {
        mouseUpCallbacks = [(NSEvent) -> Void]()
        mouseDownCallbacks = [(NSEvent) -> Void]()
        mouseMovedCallbacks = [(NSEvent) -> Void]()
        mouseEnteredCallbacks = [(NSEvent) -> Void]()
        mouseExitedCallbacks = [(NSEvent) -> Void]()
        mouseDraggedCallbacks = [(NSEvent) -> Void]()
    }
    
    
    /// Will Iinform subscirbed closures that the user has triggered a new mouse event of designated type
    func subscribe(type: MouseEventType, actions: @escaping (NSEvent) -> Void) {
        switch type {
        case .mouseUp:
            mouseUpCallbacks.append(actions)
        case .mouseDown:
            mouseDownCallbacks.append(actions)
        case .mouseMoved:
            mouseMovedCallbacks.append(actions)
        case .mouseEntered:
            mouseEnteredCallbacks.append(actions)
        case .mouseExited:
            mouseExitedCallbacks.append(actions)
        case .mouseDragged:
            mouseDraggedCallbacks.append(actions)
        }
    }
    
    override func willRemoveFromEntity() {
        clearCallbacks()
    }
}

#endif
